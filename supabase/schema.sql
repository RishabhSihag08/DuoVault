-- DuoVault: 2-Person Encrypted Chat & Media Database Schema (Supabase PostgreSQL)
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_slot TEXT NOT NULL CHECK (sender_slot IN ('p1', 'p2')),
  sender_name TEXT NOT NULL,
  text_content TEXT DEFAULT '',
  media_type TEXT CHECK (media_type IN ('none', 'image', 'video')) DEFAULT 'none',
  media_url TEXT,
  delivery_mode TEXT CHECK (delivery_mode IN ('normal', 'view_once')) DEFAULT 'normal',
  is_viewed_once BOOLEAN DEFAULT FALSE,
  reply_to_id UUID REFERENCES public.messages(id) ON DELETE SET NULL,
  reactions JSONB DEFAULT '{}'::jsonb,
  status TEXT DEFAULT 'read',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Enable sub-50ms real-time WebSocket broadcasts for WhatsApp-like sync
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;

-- Enable Row Level Security and allow anon operations for this 2-person vault
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon select" ON public.messages;
CREATE POLICY "Allow anon select" ON public.messages FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow anon insert" ON public.messages;
CREATE POLICY "Allow anon insert" ON public.messages FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow anon update" ON public.messages;
CREATE POLICY "Allow anon update" ON public.messages FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Allow anon delete" ON public.messages;
CREATE POLICY "Allow anon delete" ON public.messages FOR DELETE USING (true);

-- Permanent "Between-Chats" Range Delete RPC (callable by either Person 1 or Person 2)
CREATE OR REPLACE FUNCTION public.delete_chats_between(start_time TIMESTAMPTZ, end_time TIMESTAMPTZ)
RETURNS INTEGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE deleted_count INTEGER;
BEGIN
  DELETE FROM public.messages
  WHERE created_at >= start_time AND created_at <= end_time;
  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  RETURN deleted_count;
END;
$$;

-- View-Once Burn RPC: scrubs media_url and marks viewed_once = true immediately on close
CREATE OR REPLACE FUNCTION public.burn_view_once_media(target_id UUID)
RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE public.messages
  SET media_url = NULL, is_viewed_once = TRUE
  WHERE id = target_id AND delivery_mode = 'view_once';
END;
$$;
