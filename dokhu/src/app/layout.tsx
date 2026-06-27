import type { Metadata } from 'next'
import { ThemeProvider } from 'next-themes'
import ReactQueryProvider from '@/components/ReactQueryProvider'
import '@/app/globals.css'

export const metadata: Metadata = {
  title: 'DOKHU',
  description: '나만의 독서 플랫폼',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko" suppressHydrationWarning>
      <body>
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
          <ReactQueryProvider>
            {children}
          </ReactQueryProvider>
        </ThemeProvider>
      </body>
    </html>
  )
}
