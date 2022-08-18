import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget? child) builder;

  final T model;
  final Widget? child;

  /// 实现进入页面马上使用 model 加载数据功能
  final Function(T) onModelReady;
  final bool autoDispose;

  const ProviderWidget({Key? key, 
    required this.builder,
    required this.onModelReady,
    required this.model,
    this.child,
    this.autoDispose = true,
  }) : super(key: key);

  @override
  _ProviderWidgetState<T> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier> extends State<ProviderWidget<T>> {
  @override
  void initState() {
    widget.onModelReady.call(widget.model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 处理键盘焦点不丢失问题
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ChangeNotifierProvider<T>.value(
        value: widget.model,
        child: Consumer<T>(builder: widget.builder),
      ),
      // ChangeNotifierProvider<T>(
      //   create: (BuildContext context) => widget.model,
      //   child: Consumer<T>(
      //     builder: widget.builder,
      //     child: widget.child,
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    if (widget.autoDispose) widget.model.dispose();
    super.dispose();
  }
}
