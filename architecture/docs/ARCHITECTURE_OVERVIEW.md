# Bopha AI Architecture Overview

**Project**: Bopha - Khmer AI Podcast Learning Platform  
**Status**: Week 1 (Data Collection Phase)  
**Team**: 8 people  
**Last Updated**: October 2025

---

## Executive Summary

**Bopha** is a groundbreaking AI-powered educational platform designed specifically for Cambodian students. It transforms any content (PDFs, videos, web links, audio) into natural-sounding Khmer podcasts and interactive learning materials.

### Current Status (Week 1)

- ✅ **Proof of Concept Complete**: Successfully demonstrated using Google Gemini APIs
- ✅ **Teacher Approval**: Received approval and $150-250 budget
- 🔄 **Data Collection Phase**: Currently recording 30-60 hours of Khmer audio with 6 voice actors
- 🎯 **Goal**: Replace Google APIs with custom fine-tuned models for better Khmer quality and cost savings

### Key Achievements

- **Cost Reduction**: Target 82% reduction ($0.045 → $0.008 per generation)
- **Quality Improvement**: Target 68% improvement (2.5/5 → 4.2/5 Khmer naturalness)
- **Voice Customization**: From 2 fixed voices to 6 custom Khmer voices
- **Data Privacy**: From external API to self-hosted on RTX 6000 Pro

---

## Architecture Layers

### 1. Frontend Layer (Unchanged)

**Technology**: Next.js 15, React 19, TypeScript

**Components**:

- **T2V Studio**: 3-panel layout for document upload, content generation, and preview
- **V2V Voice Chat**: Real-time AI conversation with voice-to-voice interaction
- **Library Browser**: Workspace management and organization
- **Feature Modals**: Mindmap viewer, flashcard study mode, quiz interface

### 2. Middleware Layer

**Technology**: Next.js Middleware, Better Auth

**Responsibilities**:

- Route protection (authenticated routes: `/t2v`, `/library`, `/v2v`)
- Session validation via cookies
- User authentication state management

### 3. API Routes Layer

**Technology**: Next.js API Routes (App Router)

**Endpoints**:

- `/api/generate` - Content generation pipeline
- `/api/upload` - File upload and processing
- `/api/audio/*` - Audio file management
- `/api/library/*` - Library CRUD operations
- `/api/auth/*` - Better Auth handlers

### 4. Service Layer

#### Current (Google APIs)

- `GenPodcastService`: Orchestrates Outline → Script → Audio pipeline
- `FileUploadService`: Handles file uploads to Gemini File API (auto-splits >45MB)
- `conversationService`: TTS generation via Gemini Pro-TTS
- `geminiLiveServer`: Real-time voice chat via Gemini Live Audio
- `contentPartsHelper`: Prepares documents for Gemini API

#### Target (Custom AI)

- `GenPodcastService`: Custom pipeline with RAG integration
- `FileUploadService`: OCR, text extraction, vector embeddings
- `RAG Service`: Semantic search via ChromaDB
- `Embedding Service`: Khmer-capable embeddings
- `Custom WebSocket Server`: Voice chat with Qwen 3 + VibeVoice

### 5. AI Model Layer

#### Current (Google Gemini)

| Model                 | Purpose            | Latency | Cost              |
| --------------------- | ------------------ | ------- | ----------------- |
| Gemini 2.5 Flash Lite | Outline generation | 5-10s   | $0.002            |
| Gemini 2.5 Flash      | Script generation  | 15-30s  | $0.015            |
| Gemini 2.5 Pro-TTS    | Audio synthesis    | 20-40s  | $0.028            |
| Gemini Live Audio     | Voice chat         | 180ms   | Usage-based       |
| Gemini File API       | File processing    | 10-30s  | Free (48hr cache) |

**Total**: $0.045 per generation, ~45-80s

#### Target (Custom Stack)

| Model                     | Purpose                    | Latency   | Cost     |
| ------------------------- | -------------------------- | --------- | -------- |
| Qwen 3 7B (fine-tuned)    | Outline + Script           | 10s + 16s | $0.003   |
| VibeVoice 7B (fine-tuned) | Audio synthesis (6 voices) | 15-25s    | $0.005   |
| Faster-Whisper Large-v3   | Speech-to-text             | 60ms      | Included |
| ChromaDB + BGE-M3         | RAG semantic search        | <100ms    | Included |

**Total**: $0.008 per generation, ~35-57s

### 6. Database Layer

**Technology**: Supabase (PostgreSQL + Storage)

**Schema** (via Prisma ORM):

- **User**: id, email, username, role, emailVerified
- **Session**: id, userId, token, expiresAt
- **Library**: id, userId, name, description, data (JSON with documents + generatedContent)
- **Account**: OAuth provider accounts

### 7. Infrastructure Layer

#### Current (PoC)

- **Hosting**: Vercel (Next.js)
- **Database**: Supabase Cloud
- **AI**: Google Gemini APIs (external)
- **Storage**: Local `/generated-audio/` + Supabase

#### Target (Custom)

- **Hosting**: Vercel (Next.js frontend unchanged)
- **Database**: Supabase Cloud (unchanged)
- **AI**: RTX 6000 Pro (48GB) with Docker Compose
  - LLM: 50% GPU (~24GB)
  - TTS: 30% GPU (~14GB)
  - STT: 20% GPU (~10GB)
- **Storage**: Supabase Storage + ChromaDB (500GB SSD)

---

## Data Flow

### Content Generation Pipeline

```
User uploads document → API Route
    ↓
Prepare content parts (files, links, YouTube)
    ↓
Generate Outline (LLM)
    ↓
Generate Script (LLM with Outline context)
    ↓
Generate Audio (TTS with multi-speaker)
    ↓
Save to storage + database
    ↓
Return to user (audio player + transcript)
```

### Voice Chat Pipeline

```
User speaks → AudioRecorder (WebRTC)
    ↓
WebSocket stream → STT (Speech-to-Text)
    ↓
Text → Dialog LLM (with context)
    ↓
Response text → TTS (Text-to-Speech)
    ↓
Audio stream → AudioContext playback
    ↓
Display transcript in real-time
```

---

## Legend & Notation

### Color Scheme

- 🔵 **Frontend (#3B82F6)**: Next.js, React components
- 🟢 **API Layer (#10B981)**: API routes, services
- 🟠 **Google AI (#F59E0B)**: External Gemini APIs
- 🟣 **Custom AI (#8B5CF6)**: Self-hosted models
- 🔷 **Database (#6366F1)**: PostgreSQL, Supabase
- ⚫ **Infrastructure (#6B7280)**: Docker, GPU, monitoring

### Icons

- 🧠 Model Server / LLM
- 🎤 Audio / TTS / Voice
- 🔍 RAG / Vector Search
- 💾 Storage / Database
- 🎮 GPU
- 👥 Team / Collaboration
- 📚 Education / Learning
- ⚡ Cache / Fast operation
- 🔒 Security / Privacy

### Diagram Types

- **Mermaid (.mmd)**: High-level architecture, flowcharts, workflows
- **PlantUML (.puml)**: Detailed sequence diagrams, component diagrams, deployment diagrams
- **ASCII**: Quick reference in READMEs

---

## Component Responsibility Matrix (RACI)

| Component          | Responsible  | Accountable | Consulted       | Informed |
| ------------------ | ------------ | ----------- | --------------- | -------- |
| Frontend (Next.js) | Tech Lead    | Tech Lead   | Team            | All      |
| API Routes         | Tech Lead    | Tech Lead   | Teacher         | Team     |
| Google APIs (PoC)  | Google       | Tech Lead   | -               | Team     |
| Custom Models      | Tech Lead    | Teacher     | Voice Reviewers | All      |
| Dataset Collection | Voice Actors | Tech Lead   | Script Writers  | Teacher  |
| Fine-Tuning        | Tech Lead    | Teacher     | QA Testers      | All      |
| QA Testing         | QA Testers   | Teacher     | All Team        | -        |
| Deployment         | Tech Lead    | Teacher     | -               | All      |
| Documentation      | Tech Lead    | Tech Lead   | -               | All      |

**Key**:

- **R** (Responsible): Does the work
- **A** (Accountable): Ultimately answerable
- **C** (Consulted): Provides input
- **I** (Informed): Kept up-to-date

---

## Network Architecture

### Current (Google APIs)

```
[User] → [Vercel Next.js] → [Next.js API Routes]
                                    ↓
                          [Google Gemini APIs]
                                    ↓
                          [Supabase PostgreSQL]
```

### Target (Custom AI)

```
[User] → [Vercel Next.js] → [Next.js API Routes]
                                    ↓
                          [RTX 6000 Pro Server]
                                    ↓
              [Qwen 3] [VibeVoice] [Whisper] [ChromaDB]
                                    ↓
                          [Supabase PostgreSQL + Storage]
```

---

## Key Design Decisions

### 1. Why Custom Models?

- **Khmer Quality**: Google models produce robotic, unnatural Khmer speech (2.5/5)
- **Cost**: Google APIs are 5-6x more expensive than self-hosted
- **Control**: Cannot fine-tune voices or add cultural context
- **Privacy**: Sensitive educational content stays on local infrastructure

### 2. Why Qwen 3?

- **Multilingual**: Better support for Khmer language
- **Efficient**: 7B parameter model runs well on RTX 6000 Pro
- **Fine-tunable**: LoRA/QLoRA adapters for efficient training
- **Alternative Options**: Llama 3.2/3.3 or Qwen 3 Multimodal

### 3. Why VibeVoice 7B?

- **Quality**: Microsoft's high-quality TTS model
- **Multi-speaker**: Supports 6 distinct voice profiles
- **Fine-tunable**: Can be adapted to Khmer pronunciation
- **Streaming**: Real-time audio generation

### 4. Why ChromaDB?

- **Simplicity**: Easy to deploy and manage
- **Performance**: Fast vector similarity search
- **Summarization**: Stores context summaries instead of full documents (cost-effective)
- **Khmer Support**: Works with Khmer-capable embedding models

### 5. Why RTX 6000 Pro?

- **Budget-Friendly**: Available for training at $0.27-$1/hour
- **Sufficient Memory**: 48GB handles all 3 models (LLM, TTS, STT)
- **Single Server**: Simplifies deployment vs distributed setup

---

## Security & Privacy

### Data Protection

- **In Transit**: TLS 1.3 encryption (HTTPS)
- **At Rest**: Supabase encryption, local SSD encryption
- **Access Control**: Better Auth + session management
- **Rate Limiting**: 100 requests/minute per user (Nginx)

### Compliance

- **Data Residency**: All processing on local/Cambodian infrastructure (target)
- **No External Sharing**: Data never sent to third-party APIs (custom stack)
- **Right to Deletion**: GDPR-compliant user data deletion via Supabase

### Audit Logging

- **Anonymized Logs**: Request type, timestamp, user_id (hashed)
- **No Content Logging**: Respect user privacy
- **Monitoring**: Prometheus + Grafana dashboards

---

## Performance Targets

| Metric               | Google APIs (Current) | Custom AI (Target) | Improvement              |
| -------------------- | --------------------- | ------------------ | ------------------------ |
| Outline Generation   | 8s                    | 10s                | +25% slower              |
| Script Generation    | 22s                   | 16s                | -27% faster              |
| Audio Generation     | 35s                   | 20s                | -43% faster              |
| **Total Pipeline**   | **65s**               | **46s**            | **-29% faster**          |
| Voice Chat Latency   | 180ms                 | 220ms              | +22% slower (acceptable) |
| **Cost per Request** | **$0.045**            | **$0.008**         | **-82% cheaper**         |
| Khmer Quality (1-5)  | 2.5                   | 4.2 (target)       | +68% better              |
| Voices Available     | 2 fixed               | 6 custom           | +200%                    |

---

## Roadmap Summary

| Phase                    | Timeline    | Status         | Key Deliverables                |
| ------------------------ | ----------- | -------------- | ------------------------------- |
| Phase 0: PoC             | Week 0      | ✅ Complete    | Working demo with Google APIs   |
| Phase 1: Data Collection | Weeks 1-4   | 🔄 In Progress | 30-60 hours Khmer audio dataset |
| Phase 2: Fine-Tuning     | Weeks 5-6   | ⏳ Planned     | Qwen 3 + VibeVoice 7B models    |
| Phase 3: Infrastructure  | Weeks 7-8   | ⏳ Planned     | Docker deployment, ChromaDB     |
| Phase 4: Gradual Rollout | Weeks 9-10  | ⏳ Planned     | 10% → 50% traffic to custom AI  |
| Phase 5: Full Cutover    | Weeks 11-12 | ⏳ Planned     | 100% custom AI, optimize        |
| Phase 6: Showcase        | Week 13     | ⏳ Planned     | 7-min STEM presentation         |

---

## References

- **Main Repository**: `/Users/mense/[1] Work/ProjectVoice-NotebookLM-style- BOPHA/Bopha/`
- **Diagrams**: `architecture/diagrams/`
- **Code Documentation**: `CLAUDE.md` (root directory)
- **Team Collaboration**: Notion workspace (internal)
- **Monitoring**: Grafana dashboards (to be deployed)

---

## Contact & Responsibilities

- **Tech Lead**: You (AI integration, deployment, documentation)
- **Script Writers**: 2 team members (content creation)
- **Voice Reviewers**: 2 team members (quality assurance)
- **QA Testers**: 2 team members (A/B testing, bug reports)
- **Teacher Advisor**: 1 (educational oversight, final approval)

**Total Team**: 8 people collaborating in parallel for maximum efficiency

---

_Last updated: October 2025 | Week 1 of Data Collection Phase_
