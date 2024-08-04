import 'package:coded_harmony_test/utilities/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/job_json.dart';
import '../../model/job_model.dart';
import '../../utilities/color_constant.dart';
import '../../utilities/font_style.dart';
import '../../utilities/images.dart';

class JobListingScreen extends StatefulWidget {
  @override
  _JobListingScreenState createState() => _JobListingScreenState();
}

class _JobListingScreenState extends State<JobListingScreen> with TickerProviderStateMixin {
  List<String> selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            // Desktop UI
            return buildDesktopUI(constraints.maxWidth);
          } else {
            // Mobile UI
            return buildMobileUI();
          }
        },
      ),
      backgroundColor: ColorConstant.lightGrayishCyanBG,
    );
  }

  Widget buildMobileUI() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: SvgPicture.asset(
                  ImagesSvg.bgHeaderMobile,
                  fit: BoxFit.cover,
                ),
              ),
              if (selectedFilters.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: buildFilterBar(),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: buildJobList(MediaQuery.of(context).size.width),
        ),
      ],
    );
  }

  Widget buildDesktopUI(double width) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: SvgPicture.asset(
            width > 768 ? ImagesSvg.bgHeaderDesktop : ImagesSvg.bgHeaderMobile,
            fit: BoxFit.cover,
          ),
        ),
        SizedBoxExtension.height(10),
        if (selectedFilters.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buildFilterBar(),
          ),
        Expanded(
          child: buildJobList(width),
        ),
      ],
    );
  }

  Widget buildFilterBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8.0,
              children: selectedFilters
                  .map((filter) => customFilterChips(filter, () {
                        setState(() {
                          selectedFilters.remove(filter);
                        });
                      }))
                  .toList(),
            ),
          ),
          if (selectedFilters.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  selectedFilters = [];
                });
              },
              child: const Text('Clear'),
            ),
        ],
      ),
    );
  }

  Widget buildJobList(double width) {
    List<Job> filteredJobs = jobs.where((job) {
      return selectedFilters
          .every((filter) => job.languages.contains(filter) || job.tools.contains(filter));
    }).toList();

    return ListView.builder(
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) {
        return width > 768
            ? buildJobCardDeskTop(jobs[index], width)
            : buildJobCard(filteredJobs[index], width);
      },
    );
  }

  Widget buildJobCardDeskTop(Job job, double width) {
    return Card(
      margin: const EdgeInsets.only(top: 40.0, left: 16, right: 16),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: const Border(left: BorderSide(color: ColorConstant.primary, width: 5)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  job.logo,
                  height: width > 768 ? 100 : 60,
                  width: width > 768 ? 100 : 60,
                ),
                SizedBoxExtension.width(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                job.company,
                                style: FontStyleClass.txt24_700,
                              ),
                              SizedBoxExtension.width(10),
                              if (job.isNew)
                                Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.primary,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Text(
                                    'NEW!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              if (job.isFeatured)
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.darkGreen,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Text(
                                    'FEATURED',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                          SizedBoxExtension.height(10),
                          Text(
                            job.position,
                            style: FontStyleClass.txt20_500,
                          ),
                        ],
                      ),
                    ),
                    SizedBoxExtension.height(8),
                    Row(
                      children: [
                        Text(job.postedAt),
                        SizedBoxExtension.width(4),
                        Container(
                          height: 4,
                          width: 4,
                          decoration:
                              const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                        ),
                        SizedBoxExtension.width(4),
                        Text(job.contract),
                        SizedBoxExtension.width(4),
                        Container(
                          height: 4,
                          width: 4,
                          decoration:
                              const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                        ),
                        SizedBoxExtension.width(4),
                        Text(job.location),
                      ],
                    ),
                    SizedBoxExtension.height(8),
                  ],
                ),
                SizedBoxExtension.width(10),
              ],
            ),
            Wrap(
              spacing: 8.0,
              children: [
                ...job.languages.map((lang) => customActionChip(lang, () {
                      setState(() {
                        if (!selectedFilters.contains(lang)) {
                          selectedFilters.add(lang);
                        }
                      });
                    })),
                ...job.tools.map((tool) => customActionChip(tool, () {
                      setState(() {
                        if (!selectedFilters.contains(tool)) {
                          selectedFilters.add(tool);
                        }
                      });
                    }))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJobCard(Job job, double width) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(top: 40.0, left: 16, right: 16),
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: const Border(left: BorderSide(color: ColorConstant.primary, width: 5)),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            job.company,
                            style: FontStyleClass.txt24_700,
                          ),
                          SizedBoxExtension.width(10),
                          if (job.isNew)
                            Container(
                              margin: const EdgeInsets.only(right: 8.0),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: ColorConstant.primary,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: const Text(
                                'NEW!',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          if (job.isFeatured)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: ColorConstant.darkGreen,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: const Text(
                                'FEATURED',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      SizedBoxExtension.height(10),
                      Text(
                        job.position,
                        style: FontStyleClass.txt20_500,
                      ),
                    ],
                  ),
                ),
                SizedBoxExtension.height(8),
                Row(
                  children: [
                    Text(job.postedAt),
                    SizedBoxExtension.width(4),
                    Container(
                      height: 4,
                      width: 4,
                      decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                    ),
                    SizedBoxExtension.width(4),
                    Text(job.contract),
                    SizedBoxExtension.width(4),
                    Container(
                      height: 4,
                      width: 4,
                      decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                    ),
                    SizedBoxExtension.width(4),
                    Text(job.location),
                  ],
                ),
                SizedBoxExtension.height(8),
                const Divider(
                  height: 5,
                  color: Colors.grey,
                ),
                SizedBoxExtension.height(8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    ...job.languages.map((lang) => customActionChip(lang, () {
                          setState(() {
                            if (!selectedFilters.contains(lang)) {
                              selectedFilters.add(lang);
                            }
                          });
                        })),
                    ...job.tools.map((tool) => customActionChip(tool, () {
                          setState(() {
                            if (!selectedFilters.contains(tool)) {
                              selectedFilters.add(tool);
                            }
                          });
                        }))
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 30,
          top: 12,
          child: SvgPicture.asset(
            job.logo,
            height: width > 768 ? 100 : 60,
            width: width > 768 ? 100 : 60,
          ),
        ),
      ],
    );
  }
}

Widget customFilterChips(String text, GestureTapCallback onDeleted) {
  return Container(
    padding: const EdgeInsets.only(
      left: 10,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: ColorConstant.primary.withOpacity(0.1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: ColorConstant.primary),
        ),
        SizedBoxExtension.width(4),
        InkWell(
          onTap: onDeleted,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: ColorConstant.primary,
            ),
            child: const Icon(Icons.close),
          ),
        ),
      ],
    ),
  );
}

Widget customActionChip(String text, GestureTapCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorConstant.primary.withOpacity(0.1),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14, color: ColorConstant.primary),
      ),
    ),
  );
}
