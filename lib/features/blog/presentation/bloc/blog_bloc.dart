// lib/features/blog/presentation/bloc/blog_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/blog_post.dart';
import '../../domain/usecases/get_blog_posts_usecase.dart';

// ============================================================================
// Events
// ============================================================================

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

class LoadBlogPosts extends BlogEvent {}
class RefreshBlogPosts extends BlogEvent {}

// ============================================================================
// States
// ============================================================================

abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object?> get props => [];
}

class BlogInitial extends BlogState {}
class BlogLoading extends BlogState {}
class BlogLoaded extends BlogState {
  final List<BlogPost> posts;
  const BlogLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}
class BlogError extends BlogState {
  final String message;
  const BlogError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================================================
// BLoC
// ============================================================================

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetBlogPostsUseCase getBlogPosts;

  BlogBloc({required this.getBlogPosts}) : super(BlogInitial()) {
    on<LoadBlogPosts>(_onLoadBlogPosts);
    on<RefreshBlogPosts>(_onRefreshBlogPosts);
  }

  Future<void> _onLoadBlogPosts(
    LoadBlogPosts event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());
    await _fetchBlogPosts(emit);
  }

  Future<void> _onRefreshBlogPosts(
    RefreshBlogPosts event,
    Emitter<BlogState> emit,
  ) async {
    await _fetchBlogPosts(emit);
  }

  Future<void> _fetchBlogPosts(Emitter<BlogState> emit) async {
    try {
      final posts = await getBlogPosts.call();
      emit(BlogLoaded(posts));
    } catch (e, stackTrace) {
      logError('Failed to load blog posts', e, stackTrace);
      emit(BlogError(e.toString()));
    }
  }
}