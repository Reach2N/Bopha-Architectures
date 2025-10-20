# Bopha Fine-Tuning Workflow

**Purpose**: Document the complete workflow for collecting data, annotating, and fine-tuning custom Khmer AI models  
**Timeline**: Weeks 1-6  
**Budget**: $100-150 (data collection) + $9-72 (fine-tuning)

---

## Table of Contents

1. [Voice Recording Setup](#voice-recording-setup)
2. [Recording Sessions](#recording-sessions)
3. [Audio Processing Pipeline](#audio-processing-pipeline)
4. [Dataset Annotation](#dataset-annotation)
5. [Fine-Tuning Process](#fine-tuning-process)
6. [Evaluation Metrics](#evaluation-metrics)
7. [Troubleshooting](#troubleshooting)

---

## 1. Voice Recording Setup

### Equipment Needed

- **Microphone**: USB condenser microphone (e.g., Blue Yeti, Audio-Technica AT2020)
- **Audio Interface**: Built-in or external (48kHz, 16/24-bit)
- **Computer**: Any laptop/desktop with Audacity or similar
- **Environment**: Quiet room with minimal echo

### Software Setup

```bash
# Install Audacity (free, cross-platform)
# macOS
brew install --cask audacity

# Windows
winget install Audacity.Audacity

# Linux
sudo apt install audacity
```

### Recording Settings

```
Format: WAV
Sample Rate: 48kHz
Bit Depth: 16-bit (or 24-bit if available)
Channels: Mono (1 channel)
Gain: -12 to -6 dB (avoid clipping)
```

### Pre-Recording Checklist

- [ ] Microphone positioned 6-8 inches from speaker
- [ ] Room is quiet (no fans, AC, traffic noise)
- [ ] Pop filter or windscreen attached
- [ ] Test recording: Check levels, listen for quality
- [ ] Scripts prepared and printed
- [ ] Water available for voice actors

---

## 2. Recording Sessions

### Session Schedule (Week 2)

| Day | Voice Actor | Duration | Target           |
| --- | ----------- | -------- | ---------------- |
| Mon | Host        | 3 hours  | 15-20 dialogues  |
| Tue | Expert      | 3 hours  | 15-20 dialogues  |
| Wed | Teacher     | 3 hours  | 15-20 dialogues  |
| Thu | Narrator    | 3 hours  | 10-15 narrations |
| Fri | Student     | 2 hours  | 10-15 Q&A        |
| Sat | Guest       | 2 hours  | 10-15 interviews |

### Recording Procedure

1. **Warm-up**: Actor reads 2-3 practice sentences
2. **Check levels**: Ensure peak is at -12 to -6 dB
3. **Record dialogue**:
   - Read script naturally
   - Pause 2 seconds between sentences
   - Re-record if mistakes (mark with "Take 2", "Take 3")
4. **Save immediately**: `voice-{actor}-session{N}-{timestamp}.wav`
5. **Backup**: Copy to external drive or cloud

### Recording Tips

- **Natural Speech**: Encourage fillers ("អឺ", "អញ្ចឹង"), pauses, emotion
- **Consistency**: Same distance from mic throughout
- **Breaks**: 10-minute break every hour
- **Re-records**: Don't hesitate to redo poor takes

### File Naming Convention

```
voice-host-session1-20251020-1430.wav
voice-expert-session2-20251021-0900.wav
voice-teacher-session1-20251022-1100.wav
```

---

## 3. Audio Processing Pipeline

### Week 3: Cleaning & Segmentation

#### Step 1: Normalize Audio

```bash
# Using ffmpeg (install: brew install ffmpeg)
ffmpeg -i input.wav -af "loudnorm=I=-16:TP=-1.5:LRA=11" output-normalized.wav
```

**Target**: -16 LUFS (Loudness Units Full Scale)

#### Step 2: Remove Silence

```bash
# Remove silence longer than 1 second
ffmpeg -i input.wav -af "silenceremove=stop_periods=-1:stop_duration=1:stop_threshold=-50dB" output-nosilence.wav
```

#### Step 3: Split into Segments

```python
# split_audio.py
from pydub import AudioSegment
from pydub.silence import split_on_silence

audio = AudioSegment.from_wav("input.wav")

# Split on silence (>500ms, <-40dB)
segments = split_on_silence(
    audio,
    min_silence_len=500,  # 500ms
    silence_thresh=-40,    # -40dB
    keep_silence=200       # Keep 200ms of silence
)

# Export segments
for i, segment in enumerate(segments):
    if len(segment) < 30000:  # <30 seconds
        segment.export(f"segment-{i:04d}.wav", format="wav")
    else:
        print(f"Warning: Segment {i} is too long ({len(segment)/1000}s)")
```

#### Step 4: Quality Check

- [ ] Listen to random samples (10%)
- [ ] Check for clipping, distortion, noise
- [ ] Verify consistent volume levels
- [ ] Remove or re-record poor quality segments

### Batch Processing Script

```bash
#!/bin/bash
# process_all.sh

for file in voice-*.wav; do
    echo "Processing $file..."

    # Normalize
    ffmpeg -i "$file" -af "loudnorm=I=-16" "temp-$file"

    # Remove silence
    ffmpeg -i "temp-$file" -af "silenceremove=stop_periods=-1:stop_duration=1:stop_threshold=-50dB" "clean-$file"

    # Clean up temp
    rm "temp-$file"

    echo "✓ $file processed"
done

echo "All files processed! Running segmentation..."
python split_audio.py
```

---

## 4. Dataset Annotation

### Week 4: Transcription & Metadata

#### Annotation Schema (JSON)

```json
{
  "audio_file": "segment-0042.wav",
  "speaker_id": "host",
  "duration_ms": 18500,
  "transcription": {
    "khmer": "សួស្តី! យើងនឹងនិយាយអំពីប្រវត្តិសាស្ត្រកម្ពុជា។",
    "romanized": "Suostei! Yoeung nung niyeay ompii pravattisastr Kampuchea.",
    "english_translation": "Hello! We will talk about Cambodian history."
  },
  "timestamp": {
    "start_ms": 0,
    "end_ms": 18500,
    "words": [
      { "word": "សួស្តី", "start": 0, "end": 800, "confidence": 0.98 },
      { "word": "យើង", "start": 900, "end": 1200, "confidence": 0.95 }
    ]
  },
  "features": {
    "emotion": "enthusiastic",
    "speaking_rate": "normal",
    "fillers": ["អឺ"],
    "pauses_ms": [2000],
    "pitch_variation": "moderate",
    "cultural_context": ["cambodian_greeting", "historical_topic"]
  },
  "quality": {
    "audio_clarity": 5,
    "transcription_confidence": 0.97,
    "speaker_consistency": true,
    "background_noise": "none"
  },
  "metadata": {
    "recording_date": "2025-10-21",
    "session_id": "session1",
    "reviewed_by": ["reviewer1", "reviewer2"],
    "approved": true
  }
}
```

#### Annotation Tools

1. **Audacity**: Manual transcription + timestamp marking
2. **Google Sheets**: Collaborative team annotation
3. **Python Script**: JSON generation from spreadsheet

#### Team Workflow

- **Voice Reviewers (2)**: Transcribe Khmer text, mark timestamps
- **Script Writers (2)**: Add romanization and English translation
- **QA Testers (2)**: Verify quality, add emotion tags
- **Teacher Advisor**: Final approval of cultural appropriateness

### Annotation Spreadsheet Template

| File             | Speaker | Khmer | Romanized | English | Emotion | Fillers | Quality | Approved |
| ---------------- | ------- | ----- | --------- | ------- | ------- | ------- | ------- | -------- |
| segment-0001.wav | host    | ...   | ...       | ...     | curious | អឺ      | 5/5     | ✅       |
| segment-0002.wav | expert  | ...   | ...       | ...     | patient | អញ្ចឹង  | 4/5     | ✅       |

### Export to JSON

```python
# export_annotations.py
import pandas as pd
import json

df = pd.read_csv("annotations.csv")

annotations = []
for _, row in df.iterrows():
    annotation = {
        "audio_file": row["File"],
        "speaker_id": row["Speaker"],
        "transcription": {
            "khmer": row["Khmer"],
            "romanized": row["Romanized"],
            "english_translation": row["English"]
        },
        "features": {
            "emotion": row["Emotion"],
            "fillers": row["Fillers"].split(",") if pd.notna(row["Fillers"]) else []
        },
        "quality": {"audio_clarity": int(row["Quality"])},
        "metadata": {"approved": row["Approved"] == "✅"}
    }
    annotations.append(annotation)

with open("dataset.json", "w", encoding="utf-8") as f:
    json.dump(annotations, f, ensure_ascii=False, indent=2)

print(f"✓ Exported {len(annotations)} annotations")
```

---

## 5. Fine-Tuning Process

### Week 5-6: Model Training

#### 5.1 Custom Khmer Tokenizer

```python
# train_tokenizer.py
from tokenizers import Tokenizer, models, trainers, pre_tokenizers

# Create BPE tokenizer
tokenizer = Tokenizer(models.BPE())
tokenizer.pre_tokenizer = pre_tokenizers.Whitespace()

# Train on Khmer corpus
trainer = trainers.BpeTrainer(
    vocab_size=32000,
    special_tokens=["<pad>", "<unk>", "<s>", "</s>", "<mask>"],
    min_frequency=2
)

files = ["khmer_corpus.txt", "dataset_transcriptions.txt"]
tokenizer.train(files, trainer)

# Add 2000+ Khmer educational terms
khmer_terms = [
    "ប្រវត្តិសាស្ត្រ",  # history
    "គណិតវិទ្យា",      # mathematics
    "វិទ្យាសាស្ត្រ",    # science
    # ... 2000+ more terms
]

for term in khmer_terms:
    tokenizer.add_tokens([term])

tokenizer.save("khmer_tokenizer.json")
print(f"✓ Tokenizer trained: {len(tokenizer.get_vocab())} tokens")
```

#### 5.2 Fine-Tune Qwen 3 (LLM)

```python
# finetune_qwen3.py
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import LoraConfig, get_peft_model, TaskType
from datasets import load_dataset

# Load base model
model = AutoModelForCausalLM.from_pretrained(
    "Qwen/Qwen-7B",
    torch_dtype=torch.float16,
    device_map="auto"
)

# Load custom tokenizer
tokenizer = AutoTokenizer.from_pretrained("./khmer_tokenizer.json")
model.resize_token_embeddings(len(tokenizer))

# LoRA configuration (memory-efficient)
lora_config = LoraConfig(
    task_type=TaskType.CAUSAL_LM,
    r=16,  # Low-rank dimension
    lora_alpha=32,
    lora_dropout=0.05,
    target_modules=["q_proj", "v_proj", "k_proj", "o_proj"]
)

model = get_peft_model(model, lora_config)
print(f"Trainable params: {model.print_trainable_parameters()}")

# Load dataset
dataset = load_dataset("json", data_files="dataset.json")

# Training arguments
from transformers import TrainingArguments, Trainer

training_args = TrainingArguments(
    output_dir="./qwen3-khmer-finetuned",
    num_train_epochs=3,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=2e-5,
    fp16=True,
    logging_steps=10,
    save_steps=500,
    warmup_steps=100
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=dataset["train"],
    eval_dataset=dataset["validation"]
)

# Start training
trainer.train()

# Save model
model.save_pretrained("./qwen3-khmer-final")
tokenizer.save_pretrained("./qwen3-khmer-final")

print("✓ Qwen 3 fine-tuning complete!")
```

**Training Time**: 12-24 hours on RTX 6000 Pro  
**Cost**: $3-24 (at $0.27-$1/hour)

#### 5.3 Fine-Tune VibeVoice 7B (TTS)

```python
# finetune_vibevoice.py
import torch
from vibevoice import VibeVoiceModel, VibeVoiceConfig
from datasets import load_dataset

# Load base model
config = VibeVoiceConfig.from_pretrained("microsoft/vibevoice-7b")
model = VibeVoiceModel.from_pretrained(
    "microsoft/vibevoice-7b",
    config=config,
    torch_dtype=torch.float16
)

# Load custom tokenizer
tokenizer = torch.load("./khmer_tokenizer.json")

# Load audio dataset
dataset = load_dataset(
    "audiofolder",
    data_dir="./audio_segments/",
    split="train"
)

# Fine-tune for each voice profile
voices = ["host", "expert", "teacher", "narrator", "student", "guest"]

for voice in voices:
    print(f"Training {voice} voice...")

    voice_dataset = dataset.filter(lambda x: x["speaker"] == voice)

    # Training configuration
    training_args = {
        "epochs": 5,
        "batch_size": 8,
        "learning_rate": 1e-5,
        "save_steps": 200
    }

    model.train_voice_profile(
        voice_id=voice,
        dataset=voice_dataset,
        **training_args
    )

    model.save_voice_profile(f"./vibevoice-khmer-{voice}")
    print(f"✓ {voice} voice trained")

print("✓ All 6 voices trained!")
```

**Training Time**: 24-48 hours on RTX 6000 Pro  
**Cost**: $6-48 (at $0.27-$1/hour)

---

## 6. Evaluation Metrics

### 6.1 Automated Metrics

#### Perplexity (LLM)

```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

model = AutoModelForCausalLM.from_pretrained("./qwen3-khmer-final")
tokenizer = AutoTokenizer.from_pretrained("./qwen3-khmer-final")

test_texts = ["...", "..."]  # Khmer test sentences

total_loss = 0
for text in test_texts:
    inputs = tokenizer(text, return_tensors="pt")
    outputs = model(**inputs, labels=inputs["input_ids"])
    total_loss += outputs.loss.item()

perplexity = torch.exp(torch.tensor(total_loss / len(test_texts)))
print(f"Perplexity: {perplexity:.2f}")
# Target: <30 (lower is better)
```

#### BLEU Score (Translation Quality)

```python
from sacrebleu import corpus_bleu

references = [["reference translation 1"], ["reference translation 2"]]
hypotheses = ["model output 1", "model output 2"]

bleu = corpus_bleu(hypotheses, references)
print(f"BLEU Score: {bleu.score:.2f}")
# Target: >40 (higher is better)
```

### 6.2 Human Evaluation

#### Quality Rubric (1-5 scale)

| Criterion             | 1 (Poor)           | 3 (Acceptable)   | 5 (Excellent)          |
| --------------------- | ------------------ | ---------------- | ---------------------- |
| **Natural Sound**     | Robotic, monotone  | Somewhat natural | Very human-like        |
| **Educational Value** | Confusing, unclear | Understandable   | Crystal clear          |
| **Cultural Context**  | Generic/foreign    | Some local refs  | Rich Cambodian context |
| **Technical Quality** | Glitches, noise    | Minor issues     | Perfect audio          |

#### A/B Testing Protocol

1. Generate 50 test samples (Google vs Bopha)
2. Randomize order (blind test)
3. Each QA tester rates all samples
4. Calculate average scores
5. Teacher Advisor makes final decision

**Success Criteria**:

- Natural Sound: ≥4.0/5
- Educational Value: ≥4.0/5
- Cultural Context: ≥4.0/5
- Technical Quality: ≥4.0/5
- **Bopha Preference**: >70%

---

## 7. Troubleshooting

### Common Issues

#### Issue: Audio quality inconsistent

**Solution**:

- Re-check mic positioning
- Normalize all files to -16 LUFS
- Filter out segments with SNR <20dB

#### Issue: Model overfitting (perfect train, poor test)

**Solution**:

- Reduce epochs from 5 to 3
- Increase dropout to 0.1
- Add more diverse training data

#### Issue: Khmer pronunciation errors

**Solution**:

- Review tokenizer vocabulary
- Add more Khmer-specific tokens
- Fine-tune for more epochs on problematic words

#### Issue: GPU out of memory

**Solution**:

- Reduce batch size (8 → 4)
- Use gradient accumulation
- Enable quantization (INT8)

#### Issue: Voice sounds robotic

**Solution**:

- Add more emotion variations in dataset
- Fine-tune prosody parameters
- Use lower learning rate (1e-5 → 5e-6)

### Getting Help

- **Technical Issues**: Tech Lead
- **Recording Issues**: Voice Reviewers
- **Quality Issues**: Teacher Advisor
- **Team Coordination**: Weekly Monday meetings

---

## Deliverables Checklist

### Week 1

- [ ] 6 voice actors recruited
- [ ] Recording equipment tested
- [ ] 50+ scripts created

### Week 2

- [ ] 30-60 hours audio recorded
- [ ] All files backed up
- [ ] Initial quality check passed

### Week 3

- [ ] Audio normalized and segmented
- [ ] Transcriptions complete (Khmer + Romanized)
- [ ] Timestamps aligned

### Week 4

- [ ] Annotations complete (emotions, fillers)
- [ ] Dataset split (80/10/10)
- [ ] Quality approved by teacher

### Week 5

- [ ] Custom Khmer tokenizer trained
- [ ] Qwen 3 fine-tuned
- [ ] VibeVoice 6 voices trained

### Week 6

- [ ] Models evaluated (perplexity, BLEU)
- [ ] Human evaluation complete (≥4/5)
- [ ] A/B testing shows >70% preference
- [ ] Models approved for deployment

---

**Total Budget**: $109-222  
**Total Time**: 6 weeks (80-120 hours team effort)  
**Expected Quality**: 4.2/5 (vs 2.5/5 Google)

_Document Version: 1.0 | Last Updated: October 2025_
