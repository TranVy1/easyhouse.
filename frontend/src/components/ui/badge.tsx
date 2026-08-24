import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const badgeVariants = cva(
  "inline-flex items-center justify-center rounded-full border px-2.5 py-0.5 text-xs font-semibold w-fit whitespace-nowrap shrink-0 [&>svg]:size-3 gap-1 [&>svg]:pointer-events-none focus-visible:border-primary focus-visible:ring-primary/40 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive transition-all duration-200 overflow-hidden shadow-sm",
  {
    variants: {
      variant: {
        default:
          "border-transparent bg-primary text-primary-foreground [a&]:hover:bg-primary/90 [a&]:hover:shadow-md",
        secondary:
          "border-transparent bg-secondary text-secondary-foreground [a&]:hover:bg-secondary/80 [a&]:hover:shadow-md",
        destructive:
          "border-transparent bg-destructive text-white [a&]:hover:bg-destructive/90 [a&]:hover:shadow-md focus-visible:ring-destructive/30 dark:focus-visible:ring-destructive/40 dark:bg-destructive/60",
        success:
          "border-transparent bg-success text-success-foreground [a&]:hover:bg-success/90 [a&]:hover:shadow-md",
        warning:
          "border-transparent bg-warning text-warning-foreground [a&]:hover:bg-warning/90 [a&]:hover:shadow-md",
        info:
          "border-transparent bg-info text-info-foreground [a&]:hover:bg-info/90 [a&]:hover:shadow-md",
        "soft-success":
          "border-success/20 bg-success/10 text-success [a&]:hover:bg-success/20",
        "soft-warning":
          "border-warning/20 bg-warning/10 text-warning [a&]:hover:bg-warning/20",
        "soft-danger":
          "border-danger/20 bg-danger/10 text-danger [a&]:hover:bg-danger/20",
        "soft-info":
          "border-info/20 bg-info/10 text-info [a&]:hover:bg-info/20",
        "soft-neutral":
          "border-neutral/20 bg-neutral/10 text-neutral-foreground dark:text-neutral [a&]:hover:bg-neutral/20",
        outline:
          "text-foreground [a&]:hover:bg-accent [a&]:hover:text-accent-foreground [a&]:hover:shadow-md",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
)

function Badge({
  className,
  variant,
  asChild = false,
  ...props
}: React.ComponentProps<"span"> &
  VariantProps<typeof badgeVariants> & { asChild?: boolean }) {
  const Comp = asChild ? Slot : "span"

  return (
    <Comp
      data-slot="badge"
      className={cn(badgeVariants({ variant }), className)}
      {...props}
    />
  )
}

export { Badge, badgeVariants }
