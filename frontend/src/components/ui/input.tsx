import * as React from "react"

import { cn } from "@/lib/utils"

function Input({ className, type, value, onChange, ...props }: React.ComponentProps<"input">) {
  // A number input is often backed by a numeric form state. In that setup an
  // empty string is commonly parsed back to 0 by the parent before the user can
  // type the replacement value. Keep the visual field empty during that short
  // editing state, then pass the completed number to the parent as usual.
  const [isClearedForEditing, setIsClearedForEditing] = React.useState(false)

  React.useEffect(() => {
    setIsClearedForEditing(false)
  }, [value])

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (type === "number" && typeof value === "number" && event.target.value === "") {
      setIsClearedForEditing(true)
      return
    }

    setIsClearedForEditing(false)
    onChange?.(event)
  }

  return (
    <input
      type={type}
      value={type === "number" && isClearedForEditing ? "" : value}
      onChange={handleChange}
      data-slot="input"
      className={cn(
        "file:text-foreground placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground dark:bg-input/30 border-input h-9 w-full min-w-0 rounded-lg border bg-transparent px-3 py-1 text-base shadow-sm transition-all duration-200 hover:border-primary/50 outline-none file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        "focus-visible:border-primary focus-visible:ring-primary/30 focus-visible:ring-[3px]",
        "aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive",
        className
      )}
      {...props}
    />
  )
}

export { Input }
