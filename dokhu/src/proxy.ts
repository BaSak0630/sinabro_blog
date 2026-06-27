import { NextRequest, NextResponse } from 'next/server'

const PUBLIC_PATHS = ['/books', '/login', '/api/', '/_next', '/favicon']

export async function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl

  const isPublic = PUBLIC_PATHS.some(p => pathname.startsWith(p))
  if (isPublic) return NextResponse.next()

  // Spring Boot 세션 인증 확인
  const cookie = request.headers.get('cookie') ?? ''
  try {
    const res = await fetch('http://localhost:8080/users/me', {
      headers: { cookie },
      cache: 'no-store',
    })

    if (res.status === 401) {
      const loginUrl = new URL('/login', request.url)
      loginUrl.searchParams.set('from', pathname)
      return NextResponse.redirect(loginUrl)
    }
  } catch {
    const loginUrl = new URL('/login', request.url)
    return NextResponse.redirect(loginUrl)
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico).*)'],
}
