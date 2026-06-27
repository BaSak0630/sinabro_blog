import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export const SPINE_COLORS = [
  '#1e3a5f', '#2d4a1e', '#4a1e1e', '#2d1e4a',
  '#1e4a3a', '#4a3a1e', '#1e2a4a', '#3a1e2d',
  '#3d2b1f', '#1f3d2b', '#2b1f3d', '#3d1f2b',
]

export function spineColor(id: number) {
  return SPINE_COLORS[id % SPINE_COLORS.length]
}

export function formatTime(seconds: number) {
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  return `${String(h).padStart(3, '0')}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
}
