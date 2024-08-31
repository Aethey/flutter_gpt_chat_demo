package com.example.whisper_tiny_flutter.asr;

public interface IRecorderListener {
    void onUpdateReceived(String message);

    void onDataReceived(float[] samples);
}
