import React, { createContext, useContext, useState } from 'react'

export type Theme = 'dark' | 'light'

export const DARK = {
  bg: '#0f0f0f',
  sidebar: '#111111',
  card: '#1a1a1a',
  card2: '#111111',
  input: '#0a0a0a',
  border: '#2a2a2a',
  borderSub: '#1e1e1e',
  text: '#ffffff',
  textSub: '#888888',
  textMuted: '#444444',
  shelf: 'linear-gradient(to bottom, #2a2018, #1a1208)',
  shelfSide: '#1a1208',
}

export const LIGHT = {
  bg: '#f2f0eb',
  sidebar: '#1a1a1a',
  card: '#ffffff',
  card2: '#f7f5f0',
  input: '#f0ede6',
  border: '#e0dbd0',
  borderSub: '#eae7e0',
  text: '#1a1a1a',
  textSub: '#6b6b6b',
  textMuted: '#b0a898',
  shelf: 'linear-gradient(to bottom, #8B6F3A, #6B5220)',
  shelfSide: '#5a4418',
}

export type ThemeColors = typeof DARK

interface ThemeCtx {
  theme: Theme
  toggle: () => void
  isDark: boolean
  c: ThemeColors
}

const Ctx = createContext<ThemeCtx>({ theme: 'dark', toggle: () => {}, isDark: true, c: DARK })

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<Theme>(() =>
    (localStorage.getItem('dokhu-theme') as Theme) ?? 'dark'
  )

  function toggle() {
    setTheme(t => {
      const next: Theme = t === 'dark' ? 'light' : 'dark'
      localStorage.setItem('dokhu-theme', next)
      return next
    })
  }

  return (
    <Ctx.Provider value={{ theme, toggle, isDark: theme === 'dark', c: theme === 'dark' ? DARK : LIGHT }}>
      {children}
    </Ctx.Provider>
  )
}

export const useTheme = () => useContext(Ctx)
