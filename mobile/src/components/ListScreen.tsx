import type { ReactElement } from "react";
import { FlatList, RefreshControl, StyleSheet, View } from "react-native";
import { EmptyState, Loading } from "./ui";
import { colors, spacing } from "@/theme";

interface Props<T> {
  items: T[];
  loading: boolean;
  refreshing: boolean;
  error: string | null;
  onRefresh: () => void;
  keyExtractor: (item: T) => string;
  renderItem: (item: T) => ReactElement;
  emptyText?: string;
  header?: ReactElement;
}

export function ListScreen<T>({
  items,
  loading,
  refreshing,
  error,
  onRefresh,
  keyExtractor,
  renderItem,
  emptyText = "Chưa có dữ liệu",
  header,
}: Props<T>) {
  if (loading) return <Loading />;
  return (
    <View style={{ flex: 1, backgroundColor: colors.bg }}>
      <FlatList
        data={items}
        keyExtractor={keyExtractor}
        renderItem={({ item }) => renderItem(item)}
        contentContainerStyle={styles.content}
        ListHeaderComponent={header}
        ListEmptyComponent={<EmptyState text={error ?? emptyText} />}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  content: { padding: spacing.lg, paddingBottom: spacing.xl, flexGrow: 1 },
});
