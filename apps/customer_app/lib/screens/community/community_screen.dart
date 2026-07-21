import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';

class CommunityPost {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isSaved;

  const CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.isSaved = false,
  });
}

final _feedProvider = Provider<List<CommunityPost>>((ref) {
  return const [
    CommunityPost(
      id: '1',
      authorName: 'Marina Costa',
      authorAvatar: '',
      timeAgo: '2h',
      content: 'Acabei de sair do Studio Letícia com o cabelo dos sonhos! A técnica de escovação diferenciada realmente faz toda diferença. Recomendo demais!',
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600',
      likes: 24,
      comments: 5,
    ),
    CommunityPost(
      id: '2',
      authorName: 'Camila Rocha',
      authorAvatar: '',
      timeAgo: '5h',
      content: 'Participei do workshop de penteados para noivas e foi uma experiência incrível. A Letícia é muito generosa com o conhecimento dela.',
      likes: 18,
      comments: 3,
    ),
    CommunityPost(
      id: '3',
      authorName: 'Ana Beatriz',
      authorAvatar: '',
      timeAgo: '8h',
      content: 'Alguém já testou o novo tratamento de queratina? Estou pensando em agendar mas queria saber a opinião de quem já fez.',
      likes: 7,
      comments: 12,
    ),
    CommunityPost(
      id: '4',
      authorName: 'Juliana Mendes',
      authorAvatar: '',
      timeAgo: '1d',
      content: 'Meu antes e depois com o mega hair que a Letícia colocou. Ficou tão natural que nem parece aplique!',
      imageUrl: 'https://images.unsplash.com/photo-1560869713-7d0a29430803?w=600',
      likes: 42,
      comments: 8,
    ),
    CommunityPost(
      id: '5',
      authorName: 'Patrícia Oliveira',
      authorAvatar: '',
      timeAgo: '1d',
      content: 'Dica de ouro: o cronograma capilar do Studio Letícia transformou meus cabelos em 3 sessões. Resultado profissional que dura semanas.',
      likes: 31,
      comments: 6,
    ),
    CommunityPost(
      id: '6',
      authorName: 'Larissa Santos',
      authorAvatar: '',
      timeAgo: '2d',
      content: 'Hoje completei 1 ano sendo cliente VIP do Studio Letícia! Os benefícios valem muito a pena, especialmente a consultoria de imagem.',
      likes: 56,
      comments: 14,
    ),
    CommunityPost(
      id: '7',
      authorName: 'Fernanda Lima',
      authorAvatar: '',
      timeAgo: '2d',
      content: 'Alguém mais ama o cheiro dos produtos que o Studio usa? Preciso saber qual marca é para comprar para casa!',
      likes: 9,
      comments: 7,
    ),
    CommunityPost(
      id: '8',
      authorName: 'Tatiana Nunes',
      authorAvatar: '',
      timeAgo: '3d',
      content: 'Fiz o curso de tranças afro e saí de lá me sentindo uma artista. Metodologia incrível, aprendizado que levo para a vida.',
      imageUrl: 'https://images.unsplash.com/photo-1562438668-b7b2e40b1e84?w=600',
      likes: 38,
      comments: 10,
    ),
  ];
});

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final Set<String> _likedPosts = {};
  final Set<String> _savedPosts = {};

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(_feedProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      SLSpacing.space6,
                      SLSpacing.space6,
                      SLSpacing.space6,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comunidade',
                          style: SLTypography.h1.copyWith(
                            color: SLColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Compartilhe experiências',
                          style: SLTypography.body.copyWith(
                            color: SLColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space8)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = feed[index];
                      return _PostCard(
                        post: post,
                        isLiked: _likedPosts.contains(post.id),
                        isSaved: _savedPosts.contains(post.id),
                        onLike: () {
                          setState(() {
                            if (_likedPosts.contains(post.id)) {
                              _likedPosts.remove(post.id);
                            } else {
                              _likedPosts.add(post.id);
                            }
                          });
                        },
                        onSave: () {
                          setState(() {
                            if (_savedPosts.contains(post.id)) {
                              _savedPosts.remove(post.id);
                            } else {
                              _savedPosts.add(post.id);
                            }
                          });
                        },
                      );
                    },
                    childCount: feed.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space24)),
              ],
            ),
            Positioned(
              right: SLSpacing.space6,
              bottom: SLSpacing.space6,
              child: FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Em breve! Compartilhe experi\u00eancias com a comunidade.'),
                      backgroundColor: SLColors.accentGold,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                backgroundColor: SLColors.accentGold,
                foregroundColor: SLColors.textOnDark,
                shape: RoundedRectangleBorder(
                  borderRadius: SLRadius.full,
                ),
                child: const Icon(Icons.add, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLike;
  final VoidCallback onSave;

  const _PostCard({
    required this.post,
    required this.isLiked,
    required this.isSaved,
    required this.onLike,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SLSpacing.space4,
        vertical: SLSpacing.space3,
      ),
      child: SLCard(
        variant: SLCardVariant.outlined,
        padding: const EdgeInsets.all(SLSpacing.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: SLColors.bgSecondary,
                  child: Text(
                    post.authorName.isNotEmpty
                        ? post.authorName[0].toUpperCase()
                        : '?',
                    style: SLTypography.label.copyWith(
                      color: SLColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: SLSpacing.space3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: SLTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SLColors.textPrimary,
                      ),
                    ),
                    Text(
                      post.timeAgo,
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: SLSpacing.space4),
            Text(
              post.content,
              style: SLTypography.body.copyWith(
                color: SLColors.textPrimary,
                height: 1.6,
              ),
            ),
            if (post.imageUrl != null) ...[
              const SizedBox(height: SLSpacing.space4),
              ClipRRect(
                borderRadius: SLRadius.md,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  height: 180,
                  color: SLColors.bgSecondary,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: SLColors.textSecondary.withValues(alpha: 0.3),
                      size: 36,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: SLSpacing.space5),
            Row(
              children: [
                _ActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_outline,
                  label: '${post.likes}',
                  color: isLiked ? SLColors.stateError : null,
                  onTap: onLike,
                ),
                const SizedBox(width: SLSpacing.space5),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.comments}',
                  onTap: () {},
                ),
                const Spacer(),
                _ActionButton(
                  icon: isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  color: isSaved ? SLColors.accentGold : null,
                  onTap: onSave,
                ),
                const SizedBox(width: SLSpacing.space4),
                _ActionButton(
                  icon: Icons.share_outlined,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: color ?? SLColors.textSecondary,
          ),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(
              label!,
              style: SLTypography.caption.copyWith(
                color: color ?? SLColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
