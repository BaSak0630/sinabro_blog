# MD 파일 -> SQL INSERT 생성 스크립트

$docsPath = "C:\Users\babam\IdeaProjects\sinabro_blog\src\docs\basakreview_blog_posts"
$outputFile = "C:\Users\babam\IdeaProjects\sinabro_blog\src\docs\posts_insert.sql"
$accountId = 1  # DB의 test1234 계정

$files = Get-ChildItem -Path $docsPath -Filter "*.md" | Sort-Object Name

# --- frontmatter 파서 ---
function Parse-Frontmatter($lines) {
    $result = @{ title = ""; date = ""; category = ""; contentStart = 0 }
    if ($lines[0].Trim() -ne "---") { $result.contentStart = 0; return $result }

    $endIdx = -1
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -eq "---") { $endIdx = $i; break }
    }
    if ($endIdx -eq -1) { return $result }

    for ($i = 1; $i -lt $endIdx; $i++) {
        $line = $lines[$i].Trim()
        if ($line -match '^title:\s*"?(.+?)"?\s*$') { $result.title = $matches[1] }
        if ($line -match '^date:\s*"?(.+?)"?\s*$')  { $result.date  = $matches[1] }
        if ($line -match '^category:\s*"?(.+?)"?\s*$') { $result.category = $matches[1] }
    }
    $result.contentStart = $endIdx + 1
    return $result
}

# --- 날짜 변환: "2022. 4. 12. 10:08" -> "2022-04-12 10:08:00" ---
function Convert-Date($raw) {
    if ($raw -match '(\d{4})\.\s*(\d{1,2})\.\s*(\d{1,2})\.\s*(\d{1,2}):(\d{2})') {
        $y = $matches[1]; $mo = $matches[2].PadLeft(2,'0')
        $d = $matches[3].PadLeft(2,'0'); $h = $matches[4].PadLeft(2,'0'); $mi = $matches[5]
        return "$y-$mo-$d $h`:$mi`:00"
    }
    return "2022-01-01 00:00:00"
}

# --- SQL 이스케이프 ---
function Escape-Sql($s) { return $s -replace "'", "''" }

# 1단계: 카테고리 수집
$categories = @{}
foreach ($file in $files) {
    $lines = Get-Content $file.FullName -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $lines) { continue }
    $fm = Parse-Frontmatter $lines
    if ($fm.category -and -not $categories.ContainsKey($fm.category)) {
        $categories[$fm.category] = 0  # ID는 나중에 채움
    }
}

Write-Host "발견된 카테고리: $($categories.Keys -join ', ')"
Write-Host "파일 수: $($files.Count)"

# 2단계: SQL 생성
$sql = @()
$sql += "-- ============================================"
$sql += "-- DOKHU BLOG POSTS INSERT SCRIPT"
$sql += "-- Account ID: $accountId"
$sql += "-- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$sql += "-- ============================================"
$sql += ""
$sql += "SET NAMES utf8mb4;"
$sql += "SET CHARACTER SET utf8mb4;"
$sql += ""

# 카테고리 INSERT
$sql += "-- ── 카테고리 ──"
foreach ($cat in $categories.Keys | Sort-Object) {
    $escaped = Escape-Sql $cat
    $sql += "INSERT IGNORE INTO category (name) VALUES ('$escaped');"
}
$sql += ""

# 포스트 INSERT (category_id는 서브쿼리로)
$sql += "-- ── 포스트 ──"
$insertedCount = 0
foreach ($file in $files) {
    $lines = Get-Content $file.FullName -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $lines) { continue }

    $fm = Parse-Frontmatter $lines

    # content: frontmatter 이후 전체
    $contentLines = $lines[$fm.contentStart..($lines.Count - 1)]

    # "## 📷 이미지 목록" 섹션 제거 (내용 정리)
    $imgIdx = -1
    for ($i = 0; $i -lt $contentLines.Count; $i++) {
        if ($contentLines[$i] -match '##\s*📷\s*이미지\s*목록') { $imgIdx = $i; break }
    }
    if ($imgIdx -ge 0) { $contentLines = $contentLines[0..($imgIdx - 1)] }

    $content = ($contentLines -join "`n").Trim()

    $title   = if ($fm.title)    { $fm.title }    else { [System.IO.Path]::GetFileNameWithoutExtension($file.Name) }
    $catName = if ($fm.category) { $fm.category } else { "일기" }
    $regDate = Convert-Date $fm.date

    $titleEsc   = Escape-Sql $title
    $contentEsc = Escape-Sql $content
    $catEsc     = Escape-Sql $catName

    $sql += @"
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id)
VALUES (
  '$titleEsc',
  '$contentEsc',
  '$regDate',
  0,
  $accountId,
  (SELECT id FROM category WHERE name = '$catEsc' LIMIT 1)
);
"@
    $insertedCount++
}

$sql += ""
$sql += "-- 완료: $insertedCount 개 포스트"

# 파일 저장
$sql | Out-File -FilePath $outputFile -Encoding utf8 -Force

Write-Host ""
Write-Host "✅ SQL 생성 완료: $outputFile"
Write-Host "   포스트: $insertedCount 개"
Write-Host "   카테고리: $($categories.Count) 개 ($($categories.Keys -join ', '))"
