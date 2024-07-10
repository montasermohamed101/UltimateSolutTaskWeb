import 'package:flutter/cupertino.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ultimate_solution_task/core/src/app_export.dart';
import 'dart:html';

import 'package:ultimate_solution_task/features/main_screen/cubit/home_cubit.dart';

class BuildAppbar extends StatelessWidget {
  const BuildAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      var cubit = HomeCubit.get(context);
      return SliverAppBar(
        floating: true,
        pinned: true,
        snap: false,
        expandedHeight: 100.0,
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Row(
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: const Icon(Icons.vertical_distribute_outlined),
                ),
                const SizedBox(width: 8.0),
                if (screenWidth > 1100)
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CompositedTransformTarget(
                      link: cubit.layerLink,
                      child: TextField(
                        controller: cubit.searchController,
                        focusNode: cubit.searchFocusNode,
                        onTap: () => cubit.showOverlay(context),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            cubit.hideOverlay();
                          } else {
                            cubit.showOverlay(context);
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                const SizedBox(width: 16.0),
                Row(
                  children: [
                    if (screenWidth < 1100)
                      GestureDetector(
                          onTap: () {}, child: const Icon(Icons.search)),
                    GestureDetector(
                      onTap: () {},
                      child: MouseRegion(
                        onEnter: (_) => cubit.onHover(0, true),
                        onExit: (_) => cubit.onHover(0, false),
                        child: Row(
                          children: [
                            Text(
                              'English',
                              style: TextStyle(
                                color: cubit.hoverStates[0] == true ? Colors.blue : Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: cubit.hoverStates[0] == true ? Colors.blue : Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    MouseRegion(
                      onEnter: (_) => cubit.onHover(1, true),
                      onExit: (_) => cubit.onHover(1, false),
                      child: GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.notifications, color: cubit.hoverStates[1] == true ? Colors.blue : Colors.black)),
                    ),
                    const SizedBox(width: 16.0),
                    if (screenWidth > 600) ...[
                      MouseRegion(
                        onEnter: (_) => cubit.onHover(2, true),
                        onExit: (_) => cubit.onHover(2, false),
                        child: GestureDetector(
                            onTap: () {}, child: Icon(Icons.apps, color: cubit.hoverStates[2] == true ? Colors.blue : Colors.black)),
                      ),
                      const SizedBox(width: 16.0),
                      MouseRegion(
                        onEnter: (_) => cubit.onHover(3, true),
                        onExit: (_) => cubit.onHover(3, false),
                        child: GestureDetector(
                            onTap: () {}, child: Icon(Icons.settings, color: cubit.hoverStates[3] == true ? Colors.blue : Colors.black)),
                      ),
                      const SizedBox(width: 16.0),
                      MouseRegion(
                        onEnter: (_) => cubit.onHover(4, true),
                        onExit: (_) => cubit.onHover(4, false),
                        child: GestureDetector(
                            onTap: () {}, child: Icon(Icons.brightness_4, color: cubit.hoverStates[4] == true ? Colors.blue : Colors.black)),
                      ),
                      const SizedBox(width: 16.0),
                    ],
                    if (screenWidth > 1100)
                      MouseRegion(
                        onEnter: (_) => cubit.onHover(5, true),
                        onExit: (_) => cubit.onHover(5, false),
                        child: GestureDetector(
                            onTap: () {
                              if (cubit.isFullScreen == false) {
                                document.documentElement?.requestFullscreen();
                                cubit.enterFullscreen();
                              } else {
                                document.exitFullscreen();
                                cubit.exitFullscreen();
                              }
                            },
                            child: Icon(
                              cubit.isFullScreen == true ? Icons.fullscreen_exit : Icons.fullscreen,
                              color: cubit.isFullScreen == false ? AppColors.black : AppColors.primary,
                            )),
                      ),
                    const SizedBox(width: 16.0),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                    ),
                    if (screenWidth > 1100) ...[
                      const SizedBox(width: 8.0),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Doris Larson'),
                          Text('Founder', style: TextStyle(fontSize: 12.0)),
                        ],
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
