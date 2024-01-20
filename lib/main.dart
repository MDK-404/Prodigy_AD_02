import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Notes {
  final String title;
  final String content;

  Notes({required this.title, required this.content});
}

class Notifierx extends StateNotifier<List<Notes>> {
  Notifierx() : super([]);

  void addNote(Notes note) {
    state = [...state, note];
  }

  void removeNote(Notes note) {
    state = state.where((_note) => _note != note).toList();
  }

  void updateNote(Notes oldNote, Notes newNote) {
    state = state.map((note) => note == oldNote ? newNote : note).toList();
  }
}

final noteProvider = StateNotifierProvider<Notifierx, List<Notes>>(
      (ref) => Notifierx(),
);

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.lightBlue,
          secondary: Colors.lightBlueAccent,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesList = ref.watch(noteProvider);
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: contentController,
                            decoration: InputDecoration(
                              labelText: 'Content',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            final newTitle = titleController.text.trim();
                            final newContent = contentController.text.trim();

                            if (newTitle.isNotEmpty || newContent.isNotEmpty) {
                              ref.read(noteProvider.notifier).addNote(
                                Notes(
                                  title: newTitle,
                                  content: newContent,
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              // Show a popup for empty title and content
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: const Text("Title and Content cannot be empty."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: const Text('Add note'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Add Note'),
            ),
            const SizedBox(height: 20),
            notesList.isEmpty
                ? const Text('Add notes ')
                : Expanded(
              child: ListView.builder(
                itemCount: notesList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        notesList[index].title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(notesList[index].content),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              titleController.text = notesList[index].title;
                              contentController.text = notesList[index].content;
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration:   InputDecoration(
                                            labelText: 'Title',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: contentController,
                                          decoration:   InputDecoration(
                                            labelText: 'Content',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          final updatedTitle = titleController.text.trim();
                                          final updatedContent = contentController.text.trim();

                                          if (updatedTitle.isNotEmpty || updatedContent.isNotEmpty) {
                                            ref.read(noteProvider.notifier).updateNote(
                                              notesList[index],
                                              Notes(
                                                title: updatedTitle,
                                                content: updatedContent,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          } else {
                                            // Show a popup for empty title and content
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  content: const Text("Title and Content cannot be empty."),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text('Update Note'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref.read(noteProvider.notifier).removeNote(notesList[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
