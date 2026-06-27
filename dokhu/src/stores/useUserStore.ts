import { create } from 'zustand'
import type { UserProfile } from '@/types'

interface UserState {
  profile: UserProfile | null
  setProfile: (p: UserProfile | null) => void
}

export const useUserStore = create<UserState>((set) => ({
  profile: null,
  setProfile: (profile) => set({ profile }),
}))
