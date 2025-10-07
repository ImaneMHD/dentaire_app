import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userAvatarUrl;

  const ProfileHeader({
    Key? key,
    this.userAvatarUrl = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: userAvatarUrl.isNotEmpty
                    ? Image.network(
                        userAvatarUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _defaultAvatar();
                        },
                      )
                    : _defaultAvatar(),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // Action notification
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(
            color: Colors.white54,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[300],
      child: Icon(Icons.person, size: 40, color: Colors.grey[700]),
    );
  }
}
