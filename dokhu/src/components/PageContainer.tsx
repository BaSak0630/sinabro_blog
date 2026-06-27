import { cn } from '@/lib/utils'

interface Props extends React.HTMLAttributes<HTMLElement> {
  children: React.ReactNode
  as?: React.ElementType
}

export default function PageContainer({ children, as: Component = 'div', className, ...props }: Props) {
  return (
    <Component
      className={cn('no-scrollbar mx-auto w-full max-w-4xl p-6', className)}
      {...props}
    >
      {children}
    </Component>
  )
}
