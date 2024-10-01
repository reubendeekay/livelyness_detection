import 'package:livelyness_detection/index.dart';

class LivelynessDetectionStepOverlay extends StatefulWidget {
  final List<LivelynessStepItem> steps;
  final VoidCallback onCompleted;
  const LivelynessDetectionStepOverlay({
    super.key,
    required this.steps,
    required this.onCompleted,
  });

  @override
  State<LivelynessDetectionStepOverlay> createState() =>
      LivelynessDetectionStepOverlayState();
}

class LivelynessDetectionStepOverlayState
    extends State<LivelynessDetectionStepOverlay> {
  //* MARK: - Public Variables
  //? =========================================================
  int get currentIndex {
    return _currentIndex;
  }

  bool _isLoading = false;

  //* MARK: - Private Variables
  //? =========================================================
  int _currentIndex = 0;

  late final PageController _pageController;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black.withOpacity(0.2),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildBody(),
          Visibility(
            visible: _isLoading,
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black,
          //     child: Center(
          //       child: Container(
          //         color: Colors.transparent,
          //         height: MediaQuery.of(context).size.width * 0.3,
          //         width: MediaQuery.of(context).size.width * 0.3,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  //* MARK: - Public Methods for Business Logic
  //? =========================================================
  Future<void> nextPage() async {
    if (_isLoading) {
      return;
    }
    if ((_currentIndex + 1) <= (widget.steps.length - 1)) {
      //Move to next step
      _showLoader();
      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
      await Future.delayed(
        const Duration(seconds: 2),
      );
      _hideLoader();
      setState(() => _currentIndex++);
    } else {
      widget.onCompleted();
    }
  }

  void reset() {
    _pageController.jumpToPage(0);
    setState(() => _currentIndex = 0);
  }

  //* MARK: - Private Methods for Business Logic
  //? =========================================================
  void _showLoader() => setState(
        () => _isLoading = true,
      );

  void _hideLoader() => setState(
        () => _isLoading = false,
      );

  //* MARK: - Private Methods for UI Components
  //? =========================================================
  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 1,
          child: AbsorbPointer(
            absorbing: true,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.steps.length,
              itemBuilder: (context, index) {
                return _buildAnimatedWidget(
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 2.5,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.steps[index].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  isExiting: index != _currentIndex,
                );
              },
            ),
          ),
        ),
        Container(
          color: Colors.grey[200],
          height: 10,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: _currentIndex + 1,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                  ),
                ),
              ),
              Expanded(
                flex: widget.steps.length - (_currentIndex + 1),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        const Spacer(
          flex: 14,
        ),
      ],
    );
  }

  Widget _buildAnimatedWidget(
    Widget child, {
    required bool isExiting,
  }) {
    return isExiting
        ? ZoomOut(
            animate: true,
            child: FadeOutLeft(
              animate: true,
              delay: const Duration(milliseconds: 200),
              child: child,
            ),
          )
        : ZoomIn(
            animate: true,
            delay: const Duration(milliseconds: 500),
            child: FadeInRight(
              animate: true,
              delay: const Duration(milliseconds: 700),
              child: child,
            ),
          );
  }
}
