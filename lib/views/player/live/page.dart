import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/data/function.dart';
import 'package:iptv/database/xtream/streams/live.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/providers/metadata.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:iptv/widgets/my_list_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/widgets/flick_player/flick_player.dart';
import 'package:provider/provider.dart';

class LiveDetailPage extends StatelessWidget {
  final LiveStreamModel channel;

  const LiveDetailPage({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    final url =
        Functions.getHLSUrlwithExtension(context, channel.streamId ?? 0);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: context.appColorScheme.primaryContainer,
            foregroundColor: context.appColorScheme.onPrimaryContainer,
          ),
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constants.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  shape: BoxShape.rectangle,
                ),
                // child: ChewiePlayer(
                //   url: url,
                //   format: Functions.getVideoFormat(),
                //   isLive: true,
                // ),
                child: FlickPlayer(
                  url: url,
                  videoFormat: Functions.getVideoFormat(),
                  isLive: true,
                  autoPlay: true,
                ),
                // child: PlayerWidget(
                //   url: url,
                //   videoFormat: Functions.getBetterPlayerFormat(),
                //   isLive: true,
                // ),
              ),
              VerticalGap(
                height: Constants.gap,
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: Constants.padding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        channel.streamIcon?.isEmpty ?? true
                            ? Image.asset(
                                "assets/noimage.jpg",
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                channel.streamIcon ?? "",
                                fit: BoxFit.fill,
                                width: 64,
                                height: 64,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 64,
                                ),
                              ),
                        HorizontalGap(width: Constants.gap),
                        Text(
                          channel.name ?? "",
                          maxLines: 2,
                          style: context.appTextTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ],
                    ),
                    VerticalGap(height: Constants.gap / 2),
                    const Divider(),
                    VerticalGap(height: Constants.gap / 2),
                    const Text("More Channels in this category"),
                    VerticalGap(height: Constants.gap / 2),
                  ],
                ),
              ),
              Expanded(
                child: _buildChannelsList(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelsList(BuildContext context) {
    final metaData = context.read<MetaDataProvider>();
    var categoryStreams = metaData.liveStreams
        .where((stream) => stream.categoryId == channel.categoryId)
        .toList();

    categoryStreams.removeWhere((item) => item.name == channel.name);

    categoryStreams.shuffle();

    return ListView.separated(
      separatorBuilder: (_, __) => VerticalGap(height: 7.h),
      itemCount: categoryStreams.length,
      itemBuilder: (context, index) =>
          _buildChannelTile(categoryStreams[index]),
    );
  }
}

Widget _buildChannelTile(LiveStreamModel stream) {
  return MyListTile(
    title: stream.name ?? "",
    iconUrl: stream.streamIcon,
    onTap: () => _navigateToChannel(stream),
  );
}

void _navigateToChannel(LiveStreamModel stream) {
  Navigator.push(
    Get.context!,
    MaterialPageRoute(
      builder: (context) => LiveDetailPage(
        channel: stream,
      ),
    ),
  );
}
