import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFieldType { text, password }

class TextFieldWidget extends StatefulWidget {
  final TextFieldType? type;
  final TextEditingController? controller;
  final String? hint;
  final bool? enabled;
  final String? Function(String?)? onSubmitted;
  final Function()? onTap;
  final String? label;
  final TextInputType? keyboardType;
  final bool? authCorrect;
  final String? Function(String?)? onChanged;
  final Widget? icon;
  final bool? optional;
  final Color? color;
  final String? Function(String?)? validator;
  final int? maxLength;
  final String? caption;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isMandatory;
  final TextDirection? textDirection;
  final int? maxLines;

  const TextFieldWidget({
    super.key,
    @required this.type,
    this.controller,
    this.authCorrect,
    this.hint,
    this.enabled,
    this.onSubmitted,
    this.label,
    this.keyboardType,
    this.onChanged,
    this.icon,
    this.optional,
    this.color,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.isMandatory,
    this.caption,
    this.onTap,
    this.textDirection,
    this.maxLines,
  });

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  bool isVisible = false;
  Widget getContent() {
    Widget widgetComponent;
    switch (widget.type!) {
      case TextFieldType.text:
        widgetComponent = TextFormField(
          key: widget.key,
          onTap: widget.onTap,
          autocorrect: widget.authCorrect ?? true,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          validator: widget.validator,
          onFieldSubmitted: widget.onSubmitted,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters ?? [],
          maxLength: widget.maxLength,
          enabled: widget.enabled ?? true,
          controller: widget.controller,
          textInputAction: TextInputAction.done,
          maxLines: widget.maxLines,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            errorMaxLines: 5,
            isDense: true,
            labelText: widget.label,
            hintText: widget.hint ?? '',
            prefixIcon: widget.icon,
            hintStyle: Theme.of(context).textTheme.titleSmall,
            labelStyle: Theme.of(context).textTheme.titleSmall,
            floatingLabelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
            contentPadding: const EdgeInsets.all(8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.5,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
          ),
        );
        break;
      case TextFieldType.password:
        widgetComponent = TextFormField(
          obscureText: !isVisible,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters ?? [],
          maxLength: widget.maxLength,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            errorMaxLines: 5,
            isDense: true,
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: widget.icon,
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: Icon(
                isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey,
                size: 24,
              ),
            ),
            hintStyle: Theme.of(context).textTheme.titleSmall,
            labelStyle: Theme.of(context).textTheme.titleSmall,
            floatingLabelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
            contentPadding: const EdgeInsets.all(8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.5,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
          ),
        );
        break;
    }
    return widgetComponent;
  }

  @override
  Widget build(BuildContext context) {
    return getContent();
  }
}
