# Listing 6.3.1: WhisperTranscription.R
library(openai) # For OpenAI API calls
# Path to a local audio file (should be in WAV/MP3 format)
audio_file <- "example_speech.wav"
# Transcribe using Whisper model (base version)
transcription <- create_transcription(
  file = audio_file,
  model = "whisper-1"
)
# Output the transcription text
cat("Transcribed text:", transcription$text, "\n")