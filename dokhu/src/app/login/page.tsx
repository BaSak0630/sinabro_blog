import { redirect } from 'next/navigation'

export default function LoginPage({
  searchParams,
}: {
  searchParams: Promise<{ from?: string }>
}) {
  // Spring Boot 로그인 페이지로 리다이렉트
  redirect('/api/loginForm')
}
