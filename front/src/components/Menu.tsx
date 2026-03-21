import React, { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { container } from 'tsyringe'
import type UserProfile from '@/entity/user/UserProfile'
import type HttpError from '@/http/HttpError'
import AccountRepository from '@/repository/AccountRepository'
import ProfileRepository from '@/repository/ProfileRepository'

const USER_REPOSITORY = container.resolve(AccountRepository)
const PROFILE_REPOSITORY = container.resolve(ProfileRepository)

export default function Menu() {
  const [profile, setProfile] = useState<UserProfile | null>(null)

  useEffect(() => {
    USER_REPOSITORY.getProfile()
      .then((p) => {
        PROFILE_REPOSITORY.setProfile(p)
        setProfile(p)
      })
      .catch((e: HttpError) => {
        if (e.getCode() !== '401') {
          console.error('프로필 조회 실패:', e.getMessage())
        }
      })
  }, [])

  function logout() {
    alert('로그아웃 되었습니다.')
    PROFILE_REPOSITORY.clear()
    location.href = '/api/logout'
  }

  return (
    <ul
      className="list-none p-0 h-5 text-sm font-light text-left"
      style={{ marginLeft: '50px' }}
    >
      <li className="inline mr-4">
        <Link to="/blog" className="text-inherit">홈으로</Link>
      </li>

      {profile !== null && (
        <li className="inline mr-4">
          <Link to="/blog/write" className="text-inherit">글 작성</Link>
        </li>
      )}

      {profile === null ? (
        <li className="inline mr-4">
          <Link to="/login" state={{ from: '/blog' }} className="text-inherit">로그인</Link>
        </li>
      ) : (
        <li className="inline">
          <a href="#" onClick={(e) => { e.preventDefault(); logout() }} className="text-inherit">
            ({profile.accountId}) 로그아웃
          </a>
        </li>
      )}
    </ul>
  )
}
