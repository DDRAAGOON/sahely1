import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;
  const ChatMessagesLoaded(this.messages);
  @override
  List<Object?> get props => [messages];
}
class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;

  ChatCubit(this._repository) : super(ChatInitial());

  void loadMessages(String roomId) {
    emit(ChatLoading());
    _repository.getMessages(roomId).listen(
      (messages) => emit(ChatMessagesLoaded(messages)),
      onError: (err) => emit(ChatError(err.toString())),
    );
  }

  Future<void> sendMessage(String roomId, String content) async {
    final result = await _repository.sendMessage(roomId: roomId, content: content);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => null, // Message sent successfully, stream will update
    );
  }
}
