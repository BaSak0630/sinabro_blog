import React from 'react'
import { Outlet } from 'react-router-dom'
import FinTreeNav from '@/components/FinTreeNav'

export default function FinTreeLayout() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-emerald-50">
      <FinTreeNav />
      <main className="max-w-6xl mx-auto px-8 py-10">
        <Outlet />
      </main>
    </div>
  )
}
