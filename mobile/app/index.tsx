import { Loading } from "@/components/ui";

/**
 * Entry route. The actual redirect (to login / manager / tenant) is driven by
 * RootNavigator in app/_layout.tsx once auth and the navigator are ready, so
 * this screen only needs to show a spinner to avoid a competing redirect.
 */
export default function Index() {
  return <Loading />;
}
