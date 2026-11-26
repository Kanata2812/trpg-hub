-- TRPG HUB 追加設定（必要に応じて実行）
-- 既存のテーブルやポリシーは削除しません。

-- プロフィールの新規作成を本人に許可
CREATE POLICY "本人がプロフィールを作成"
ON public.profiles FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- 公開バケット内の画像を一覧取得できるようにする
CREATE POLICY "TRPG HUB 画像を閲覧"
ON storage.objects FOR SELECT
TO anon, authenticated
USING (bucket_id = 'TRPG-HUB-IMAGES');

-- アップロードした本人だけが画像を削除できるようにする
CREATE POLICY "本人が自分の画像を削除"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'TRPG-HUB-IMAGES'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- 注意：画像バケット名が実際に TRPG-HUB-IMAGES であることを確認してから実行してください。
