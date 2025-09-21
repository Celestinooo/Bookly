import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/livro_controller.dart';
import '../../model/livro.dart';
import 'package:intl/intl.dart';

class LivroFormPage extends StatefulWidget {
  final Livro? livro;

  const LivroFormPage({super.key, this.livro});

  @override
  State<LivroFormPage> createState() => _LivroFormPageState();
}

class _LivroFormPageState extends State<LivroFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  DateTime? _dataLeitura;
  bool _lido = false;

  bool get isEdit => widget.livro != null;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro?.titulo ?? '');
    _autorController = TextEditingController(text: widget.livro?.autor ?? '');
    _dataLeitura = widget.livro?.dataLeitura ?? DateTime.now();
    _lido = widget.livro?.lido ?? false;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataLeitura!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dataLeitura = picked);
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          cursorColor: Colors.red,
          style: TextStyle(color: enabled ? Colors.black : Colors.grey),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }


  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Data de Leitura', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Text(
              DateFormat('dd/MM/yyyy').format(_dataLeitura!),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }


  Widget _buildStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(_lido ? 'Lido' : 'Não Lido', style: const TextStyle(fontSize: 16, color: Colors.black)),

            Checkbox(
              value: _lido,
              activeColor: Colors.red,
              onChanged: (value) => setState(() => _lido = value ?? false),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildButtons(LivroController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final livro = Livro(
              id: widget.livro?.id,
              titulo: _tituloController.text,
              autor: _autorController.text,
              dataLeitura: _dataLeitura!,
              lido: _lido,
            );
            if (isEdit) {
              await controller.updateLivro(livro);
            } else {
              await controller.addLivro(livro);
            }
            if (mounted) Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          child: const Text('Concluir'),
        ),
        if (isEdit)
          ElevatedButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar exclusão'),
                  content: const Text('Deseja realmente excluir este livro?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await controller.deleteLivro(widget.livro!.id!);
                if (mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Excluir'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LivroController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Livro' : 'Inserir Livro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nome', _tituloController, enabled: !isEdit),
              _buildTextField('Autor', _autorController, enabled: !isEdit),
              _buildStatusField(),
              _buildDateField(),
              _buildButtons(controller),
            ],
          ),
        ),
      ),
    );
  }
}
