import React, { useEffect, useState } from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { container } from 'tsyringe'
import AccountRepository from '@/repository/AccountRepository'

const USER_REPOSITORY = container.resolve(AccountRepository)

type Status = 'loading' | 'admin' | 'unauthorized' | 'unauthenticated'

interface Props {
  children: React.ReactNode
}

export default function RequireAdmin({ children }: Props) {
  const location = useLocation()
  const [status, setStatus] = useState<Status>('loading')

  useEffect(() => {
    USER_REPOSITORY.getProfile()
      .then((profile) => {
        setStatus(profile.isAdmin() ? 'admin' : 'unauthorized')
      })
      .catch(() => {
        setStatus('unauthenticated')
      })
  }, [])

  if (status === 'loading') {
    return (
      <div className="flex items-center justify-center py-32">
        <div className="w-5 h-5 border-2 border-slate-200 border-t-slate-600 rounded-full animate-spin" />
      </div>
    )
  }

  if (status === 'unauthenticated') {
    return <Navigate to="/login" state={{ from: location.pathname }} replace />
  }

  if (status === 'unauthorized') {
    alert('글 작성은 관리자만 가능합니다.')
    return <Navigate to="/blog" replace />
  }

  return <>{children}</>
}
