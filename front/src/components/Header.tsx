import React from 'react'
import { useNavigate } from 'react-router-dom'

export default function Header() {
  const navigate = useNavigate()

  return (
    <div className="flex items-center justify-between h-16 my-4 mx-8">
      <div
        className="text-3xl font-light cursor-pointer"
        onClick={() => navigate('/blog')}
      >
        sinabro_blog
      </div>
      <div
        className="text-xs text-slate-400 cursor-pointer hover:text-slate-600"
        onClick={() => navigate('/')}
      >
        ← Sinabro 홈
      </div>
    </div>
  )
}
