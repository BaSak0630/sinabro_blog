import { useEffect, useState } from 'react'
import { container } from 'tsyringe'
import type UserProfile from '@/entity/user/UserProfile'
import AccountRepository from '@/repository/AccountRepository'
import ProfileRepository from '@/repository/ProfileRepository'

const USER_REPOSITORY = container.resolve(AccountRepository)
const PROFILE_REPOSITORY = container.resolve(ProfileRepository)

export default function useProfile(): UserProfile | null {
  const [profile, setProfile] = useState<UserProfile | null>(null)

  useEffect(() => {
    USER_REPOSITORY.getProfile()
      .then((p) => {
        PROFILE_REPOSITORY.setProfile(p)
        setProfile(p)
      })
      .catch(() => {})
  }, [])

  return profile
}