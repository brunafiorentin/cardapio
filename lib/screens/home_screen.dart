import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '/controller/event.dart';
import '/controller/generative_controller.dart';

class ScreenHome extends StatelessWidget {
  final TextEditingController _controller = TextEditingController(
    text:
        "Identifique com precisão o produto passado na imagem e forneça uma receita apropriada e consistente com sua análise. ",
  );

  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Aqui você pode gerar sua receita e descobrir novos sabores, apenas enviando uma imagem!"),
      ),
      body: BlocBuilder<GenerativeController, Event>(
        builder: (context, state) {
          if (state is InitialState) {
            return _buildInitialState();
          } else if (state is LoadingState) {
            return _buildLoadingState();
          } else if (state is OnlyPhotoState) {
            return _buildOnlyPhotoState();
          } else if (state is SuccessState) {
            return _buildSuccessState(state.result);
          } else {
            return _buildInitialState();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text("Carregando receita...")
          ],
        ),
      );

  Widget _buildSuccessState(String result) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Text(result),
              const SizedBox(
                height: 12,
              ),
              OutlinedButton(
                  onPressed: () {
                    context.read<GenerativeController>().reset();
                  },
                  child: const Text("Nova receita"))
            ],
          ),
        ),
      );

  Widget _buildOnlyPhotoState() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Image.asset(
                'assets/images/paodequeijo.jpg',
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                minLines: 4,
                maxLines: 4,
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Comando',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              _sendButton(),
            ],
          ),
        ),
      );

  Widget _buildInitialState() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      child: const Text("+ Foto da Câmera"),
                      onPressed: () => _selectPhotos(true),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: OutlinedButton(
                      child: const Text("+ Fotos da Galeria"),
                      onPressed: () => _selectPhotos(false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _sendButton() => OutlinedButton(
      onPressed: () {
        context.read<GenerativeController>().getCurrent(
            text: _controller.text,
            path: context.read<GenerativeController>().selectedPhoto!.path);
      },
      child: const Text("Enviar"));

  void _selectPhotos(bool newPhoto) async {
    final ImagePicker _picker = ImagePicker();
    XFile? photo;
    late List<XFile> images;

    if (newPhoto) {
      photo = await _picker.pickImage(
        source: ImageSource.camera,
      );
    } else {
      images = await _picker.pickMultiImage();
    }

    if (photo?.path != null) {
      context.read<GenerativeController>().setSelectedPhoto(photo!);
    } else if (images.isNotEmpty) {
      context.read<GenerativeController>().setSelectedPhoto(images.first);
    }
  }
}
