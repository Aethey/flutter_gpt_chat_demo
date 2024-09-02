
## A Flutter gpt chat demo.
![test CI](https://github.com/Aethey/flutter_gpt_chat_demo/actions/workflows/flutter_ci.yml/badge.svg)

**how to build it**:  
create a **.env** file in **root directory** with **OPENAI_API_KEY=your apiKey**

## Screenshots

|                                     |                                     |                                     |
|:-----------------------------------:|:-----------------------------------:|:-----------------------------------:|
| ![Image 1](assets/screenshot/1.png) | ![Image 2](assets/screenshot/2.png) | ![Image 3](assets/screenshot/3.png) |

## Local Whisper
For implementing Whisper on Mobile, you can refer to the following project:
[nyadla-sys/whisper.tflite](https://github.com/nyadla-sys/whisper.tflite)

### Android

To run this code, please note the following:

- **Real Device Required**: This implementation must be tested and run on a real Android device.
- **Model Files**: You need to download the model files and place them in the `assets/model/` directory located in the root of your project.
  - **Source**: The model files can be obtained from the following repository:
   [nyadla-sys/whisper.tflite](https://github.com/nyadla-sys/whisper.tflite/tree/main/whisper_android/app/src/main/assets)

  - You can use the following model files:

    | Model File                           | Description                            |
    |--------------------------------------|----------------------------------------|
    | `filters_vocab_en.bin`               | English vocabulary file                |
    | `whisper-tiny-en.tflite`             | Tiny English model file                |
    | `filters_vocab_multilingual.bin`     | Multilingual vocabulary file           |
    | `whisper-tiny.tflite`                | Tiny multilingual model file           |

    https://github.com/user-attachments/assets/92ddfa3d-44e7-4669-af8b-7adf45bffec2




