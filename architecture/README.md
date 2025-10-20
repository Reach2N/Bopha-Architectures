# Bopha AI Architecture Documentation

Welcome to the comprehensive architecture documentation for **Bopha** - the Khmer AI Podcast Learning Platform.

**Project Status**: Week 1 (Data Collection Phase)  
**Team**: 8 people collaborating  
**Budget**: $150-250 total

---

## 📂 Documentation Structure

```
architecture/
├── diagrams/
│   ├── mermaid/          # High-level architecture (renders on GitHub)
│   ├── plantuml/         # Detailed technical diagrams
│   ├── exports/          # SVG/PNG for presentations
│   └── ascii/            # Quick reference diagrams
├── docs/
│   ├── ARCHITECTURE_OVERVIEW.md       # System overview
│   ├── FINE_TUNING_WORKFLOW.md        # Dataset & training guide
│   ├── PERFORMANCE_COMPARISON.md      # Google vs Bopha metrics
│   └── (more docs)
└── README.md (this file)
```

---

## 🚀 Quick Start

### For Team Members

1. **Read First**: [ARCHITECTURE_OVERVIEW.md](docs/ARCHITECTURE_OVERVIEW.md)
2. **Current Work**: [Voice Recording Workflow](diagrams/mermaid/04-voice-recording-workflow.mmd) (Week 1-2)
3. **Training Guide**: [FINE_TUNING_WORKFLOW.md](docs/FINE_TUNING_WORKFLOW.md) (Week 5-6)

### For Presentations

- **High-Level**: [Google vs Custom Comparison](diagrams/mermaid/03-google-vs-custom.mmd)
- **Migration**: [12-Week Roadmap](diagrams/plantuml/08-migration-roadmap.puml)
- **SVG Exports**: See `diagrams/exports/` folder (coming soon)

---

## 📊 Key Diagrams

### Mermaid Diagrams (GitHub-Friendly)

| Diagram                                                                             | Description                   | Status      |
| ----------------------------------------------------------------------------------- | ----------------------------- | ----------- |
| [01-google-ai-poc.mmd](diagrams/mermaid/01-google-ai-poc.mmd)                       | Current PoC with Google APIs  | ✅ Complete |
| [02-custom-khmer-ai.mmd](diagrams/mermaid/02-custom-khmer-ai.mmd)                   | Target custom AI architecture | ✅ Complete |
| [03-google-vs-custom.mmd](diagrams/mermaid/03-google-vs-custom.mmd)                 | Side-by-side comparison       | ✅ Complete |
| [04-voice-recording-workflow.mmd](diagrams/mermaid/04-voice-recording-workflow.mmd) | 6-voice recording system      | ✅ Complete |
| [05-fine-tuning-pipeline.mmd](diagrams/mermaid/05-fine-tuning-pipeline.mmd)         | Model training workflow       | ✅ Complete |
| [06-qa-evaluation-workflow.mmd](diagrams/mermaid/06-qa-evaluation-workflow.mmd)     | Team QA & A/B testing         | ✅ Complete |

### PlantUML Diagrams (Detailed Technical)

| Diagram                                                                                      | Description                           | Status      |
| -------------------------------------------------------------------------------------------- | ------------------------------------- | ----------- |
| [07-content-generation-detailed.puml](diagrams/plantuml/07-content-generation-detailed.puml) | Sequence diagram: Generation pipeline | ✅ Complete |
| [08-migration-roadmap.puml](diagrams/plantuml/08-migration-roadmap.puml)                     | Activity diagram: 12-week timeline    | ✅ Complete |
| [09-infrastructure-deployment.puml](diagrams/plantuml/09-infrastructure-deployment.puml)     | Deployment diagram: Docker + GPU      | ✅ Complete |

---

## 📖 Documentation Guides

### Core Documentation

1. [**Architecture Overview**](docs/ARCHITECTURE_OVERVIEW.md)

   - System layers (Frontend → API → AI → Database)
   - Current (Google) vs Target (Bopha) architecture
   - Component responsibility matrix (RACI)
   - Design decisions and trade-offs

2. [**Fine-Tuning Workflow**](docs/FINE_TUNING_WORKFLOW.md)

   - Voice recording setup & tips
   - Audio processing pipeline (normalize, segment, annotate)
   - Custom Khmer tokenizer training
   - Qwen 3 + VibeVoice 7B fine-tuning
   - Evaluation metrics & troubleshooting

3. [**Performance Comparison**](docs/PERFORMANCE_COMPARISON.md)
   - Latency: Google (65s) vs Bopha (46s)
   - Cost: Google ($0.045) vs Bopha (<$0.008)
   - Quality: Google (2.5/5) vs Bopha (4.2/5)

---

## 🎨 How to View Diagrams

### Mermaid (`.mmd` files)

**Option 1: GitHub** (easiest)

- Just open any `.mmd` file on GitHub - renders automatically!

**Option 2: VS Code**

```bash
# Install Mermaid Preview extension
code --install-extension bierner.markdown-mermaid

# Open any .mmd file and press Cmd+Shift+V (Mac) or Ctrl+Shift+V (Windows)
```

**Option 3: Online**

- Visit [Mermaid Live Editor](https://mermaid.live/)
- Copy-paste diagram content
- Export as SVG/PNG

### PlantUML (`.puml` files)

**Option 1: VS Code** (recommended)

```bash
# Install PlantUML extension
code --install-extension jebbs.plantuml

# Open any .puml file and press Alt+D (preview)
```

**Option 2: Online**

- Visit [PlantText](https://www.planttext.com/)
- Copy-paste diagram content
- Generate image

**Option 3: Local CLI**

```bash
# Install PlantUML (requires Java)
brew install plantuml  # macOS
# Or download JAR from https://plantuml.com/download

# Generate SVG
plantuml -tsvg diagrams/plantuml/07-content-generation-detailed.puml

# Output: 07-content-generation-detailed.svg
```

---

## 🖼️ Exporting for Presentations

### Generate SVG Files (Slide-Ready)

```bash
cd architecture/diagrams/plantuml/

# Export all PlantUML diagrams to SVG
for file in *.puml; do
    plantuml -tsvg "$file"
done

# Move exports to exports/ folder
mv *.svg ../exports/

echo "✓ SVG files ready in diagrams/exports/"
```

### Recommended for STEM Showcase

1. **01-google-ai-poc.mmd** → Screenshot on GitHub (high-level)
2. **03-google-vs-custom.mmd** → Side-by-side comparison
3. **08-migration-roadmap.puml** → 12-week timeline (export to SVG)
4. **docs/PERFORMANCE_COMPARISON.md** → Cost/quality table

---

## 🛠️ Updating Diagrams

### Mermaid

```bash
# Edit any .mmd file directly
vi diagrams/mermaid/01-google-ai-poc.mmd

# Commit changes
git add diagrams/mermaid/01-google-ai-poc.mmd
git commit -m "Update: Add Week 2 recording status"
```

### PlantUML

```bash
# Edit any .puml file
vi diagrams/plantuml/08-migration-roadmap.puml

# Preview (VS Code: Alt+D)
# Or generate SVG manually:
plantuml -tsvg diagrams/plantuml/08-migration-roadmap.puml

# Commit
git add diagrams/plantuml/08-migration-roadmap.puml
git commit -m "Update: Adjust Week 5 training timeline"
```

---

## 🎯 Current Project Status (Week 1)

### ✅ Completed

- [x] PoC with Google APIs (working demo)
- [x] Teacher approval received
- [ ] Budget allocated ($150-250)
- [x] Architecture documentation created
- [x] Diagrams for current and target systems

### 🔄 In Progress (Week 1)

- [ ] Recruit 6 voice actors (Host, Expert, Teacher, Narrator, Student, Guest)
- [ ] Set up recording equipment (microphone, quiet room)
- [ ] Create 50+ educational scripts (Script Writers 1 & 2)
- [ ] Initial recording quality tests

### ⏳ Upcoming

- **Week 2**: Record 30-60 hours of Khmer audio
- **Week 3**: Audio processing & transcription
- **Week 4**: Annotation & QA approval
- **Week 5-6**: Model fine-tuning (Qwen 3 + VibeVoice 7B)

---

## 🤝 Team Roles

| Role                | People | Responsibilities                           |
| ------------------- | ------ | ------------------------------------------ |
| **Tech Lead**       | You    | AI integration, training, deployment, docs |
| **Script Writers**  | 2      | Create educational dialogues (50+ scripts) |
| **Voice Reviewers** | 2      | Quality check recordings, transcription    |
| **QA Testers**      | 2      | A/B testing, bug reports, user feedback    |
| **Teacher Advisor** | 1      | Educational oversight, final approval      |

**Total**: 8 people working in parallel for maximum efficiency

---

## 📞 Contact & Support

### Getting Help

- **Technical Questions**: Ask Tech Lead
- **Recording Issues**: Consult Voice Reviewers
- **Quality Concerns**: Escalate to Teacher Advisor
- **Team Coordination**: Weekly Monday meetings (1 hour)

### Communication Channels

- **Real-time**: Slack/Telegram group
- **Documentation**: This GitHub repo
- **Task Management**: Notion workspace (internal)
- **File Sharing**: Google Drive + Supabase Storage

---

## 🔗 Related Resources

### External Links

- [Qwen 3 Model](https://huggingface.co/Qwen/Qwen-7B)
- [VibeVoice 7B](https://github.com/microsoft/vibevoice)
- [Faster-Whisper](https://github.com/guillaumekln/faster-whisper)
- [ChromaDB](https://www.trychroma.com/)
- [Mermaid Documentation](https://mermaid.js.org/)
- [PlantUML Guide](https://plantuml.com/)

### Internal Links

- [Main Codebase](../) (root directory)
- [CLAUDE.md](../CLAUDE.md) (AI development guide)
- [Prisma Schema](../prisma/schema.prisma)
- [Services](../services/) (business logic)
- [Components](../components/) (UI components)

---

## 📅 Maintenance Schedule

| Task                 | Frequency                            | Owner      |
| -------------------- | ------------------------------------ | ---------- |
| Update diagrams      | After major architecture changes     | Tech Lead  |
| Review documentation | Quarterly                            | Team       |
| Export SVGs          | Before presentations                 | Tech Lead  |
| Validate metrics     | After each phase (Weeks 4, 6, 8, 12) | QA Testers |

---

## 🏆 Success Metrics

### Technical Targets

- [x] Architecture documented ✅
- [ ] Dataset: 30-60 hours annotated
- [ ] Model quality: ≥4.0/5 (Khmer)
- [ ] Cost reduction: ≥80% vs Google
- [ ] Latency: <300ms voice, <60s podcast

### Business Targets

- [ ] Break-even: 3-6 months
- [ ] User preference: >70% for Bopha
- [ ] STEM Showcase: Successful 7-min presentation
- [ ] Student adoption: 50+ active users (post-launch)

---

## 📜 Version History

| Version | Date     | Changes                            | Author    |
| ------- | -------- | ---------------------------------- | --------- |
| 1.0     | Oct 2025 | Initial architecture documentation | Tech Lead |
| 1.1     | (TBD)    | Post-training updates              | Tech Lead |

---

## 🙏 Acknowledgments

- **Team of 8**: For collaborative effort on dataset & QA
- **Teacher Advisor**: For educational guidance & approval
- **RTX 6000 Pro Access**: For affordable GPU training
- **Cambodian Students**: Our inspiration and end users

---

**🎯 Vision**: Transform Cambodian education with AI that truly understands Khmer language and culture.

**📧 Questions?** Open an issue in the GitHub repo or ask in the team Slack channel.

---

_Last Updated: October 2025 | Week 1 of 12-Week Migration_
# Bopha-Architectures
# Bopha-Architectures
