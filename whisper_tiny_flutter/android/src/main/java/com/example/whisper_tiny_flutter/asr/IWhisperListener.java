package com.example.whisper_tiny_flutter.asr;

public interface IWhisperListener {
    void onUpdateReceived(String message);
    void onResultReceived(String result);
}
