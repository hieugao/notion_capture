import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/note/models.dart';
import '../home/view_models.dart';
import 'view_models.dart';

class CreateNotePage extends ConsumerWidget {
  const CreateNotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(notionDatabaseProvider.notifier).init();
    });

    final note = ref.watch(noteProvider);
    final db = ref.watch(notionDatabaseProvider);

    final bool isEmptyLabels = note.dueString == null && note.priority == null && note.type == null;

    return Scaffold(
      appBar: AppBar(
        // backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.grey[850]),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: TextField(
                // TODO: Will use controller when editing feature is implemented.
                // controller: _titleController,
                onChanged: (value) => ref.read(noteProvider).copyWith(title: value),
                maxLines: null,
                style: Theme.of(context).textTheme.headline6,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  hintText: 'Write the title...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[800],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    // Source: https://stackoverflow.com/a/54850948/16553764
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        elevation: 16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          padding: const EdgeInsets.all(16),
                          child: _ListViewSearch(
                            tags: db.categories,
                            onTap: (tags) => ref.read(noteProvider).copyWith(categories: tags),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text('Categories'),
                        const SizedBox(width: 8),
                        db.categories.isEmpty
                            ? const _TagPropertyAddButton()
                            : Row(children: [
                                for (final NotionTag tag in db.categories) _TagProperty(tag: tag),
                              ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        elevation: 16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.85,
                          padding: const EdgeInsets.all(16),
                          child: ListView(
                            children: [
                              const Text('Lorem ipsum how uina supoin'),
                              Row(
                                children: [],
                              ),
                              const SizedBox(height: 16),
                              const Text('Due string'),
                              const SizedBox(height: 4),
                              _GridTagLabel(
                                tags: db.dueStrings,
                                onTap: (tag) => ref.read(noteProvider).copyWith(dueString: tag),
                              ),
                              const SizedBox(height: 16),
                              const Text('Due string'),
                              const SizedBox(height: 4),
                              _GridTagLabel(
                                tags: db.priorities,
                                onTap: (tag) => ref.read(noteProvider).copyWith(priority: tag),
                              ),
                              const SizedBox(height: 16),
                              const Text('Due string'),
                              const SizedBox(height: 4),
                              _GridTagLabel(
                                tags: db.types,
                                onTap: (tag) => ref.read(noteProvider).copyWith(type: tag),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text('Labels'),
                        const SizedBox(width: 8),
                        isEmptyLabels
                            ? const _TagPropertyAddButton()
                            : Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                note.dueString != null
                                    ? _TagProperty(tag: note.dueString!)
                                    : Container(),
                                note.priority != null
                                    ? _TagProperty(tag: note.priority!)
                                    : Container(),
                                note.type != null ? _TagProperty(tag: note.type!) : Container(),
                              ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.all(0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.25,
                ),
                child: TextField(
                  // controller: _bodyController,
                  onChanged: (value) => ref.read(noteProvider).copyWith(body: value),
                  decoration: const InputDecoration(
                    hintText: 'Write the content...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(noteListProvider).add(note);
          // final note = Note(
          //   id: Random().nextInt(10000),
          //   title: _titleController.text,
          //   body: _bodyController.text,
          //   categories: _categories,
          //   dueString: _dueString,
          //   priority: _priority,
          //   type: _type,
          //   createdAt: DateTime.now(),
          // );

          // Navigator.pop(context, note);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TagPropertyAddButton extends StatelessWidget {
  const _TagPropertyAddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[800],
      ),
      child: const Icon(Icons.add),
    );
  }
}

class _TagProperty extends StatelessWidget {
  const _TagProperty({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final NotionTag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[800],
      ),
      child: Text(tag.name,
          style: Theme.of(context).textTheme.bodyText2!.apply(color: tag.color.toColor())),
    );
  }
}

// Source: https://karthikponnam.medium.com/flutter-search-in-listview-1ffa40956685
// Source: https://www.kindacode.com/article/how-to-create-a-filter-search-listview-in-flutter
class _ListViewSearch extends StatefulWidget {
  const _ListViewSearch({
    Key? key,
    required this.tags,
    required this.onTap,
  }) : super(key: key);

  final List<NotionTag> tags;
  final Function(List<NotionTag>) onTap;

  @override
  _ListViewSearchState createState() => _ListViewSearchState();
}

class _ListViewSearchState extends State<_ListViewSearch> {
  TextEditingController editingController = TextEditingController();

  late List<String> _tagNames;
  List<String> _foundTags = [];
  List<NotionTag> _selectedTags = [];

  @override
  void initState() {
    _tagNames = widget.tags.map((tag) => tag.name).toList();
    _foundTags.addAll(_tagNames);
    super.initState();
  }

  void _filter(String keyword) {
    List<String> results = [];

    if (keyword.isEmpty) {
      results = _tagNames;
    } else {
      results =
          _tagNames.where((tag) => tag.toLowerCase().contains(keyword.toLowerCase())).toList();
    }

    setState(() => _foundTags = results);
  }

  void _onTap(int index) {
    final NotionTag tag = widget.tags[index];
    final bool isSelected = _selectedTags.contains(tag);

    if (!isSelected) {
      setState(() {
        _selectedTags.add(tag);
      });
      widget.onTap(_selectedTags);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              _filter(value);
            },
            controller: editingController,
            decoration: const InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _foundTags.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_foundTags[index]),
                onTap: () => _onTap(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TagLabel extends StatelessWidget {
  const _TagLabel({
    Key? key,
    required this.tag,
    required this.onTap,
    this.isSelected = false,
    this.emojiOnly = false,
  }) : super(key: key);

  final NotionTag tag;
  final Function(NotionTag) onTap;
  final bool isSelected;
  final bool emojiOnly;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(tag),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? tag.color.toColor().withOpacity(0.6) : Colors.grey[800],
            ),
            child: Text(tag.emoji,
                style: Theme.of(context).textTheme.bodyText2!.apply(color: tag.color.toColor())),
          ),
          const SizedBox(width: 6),
          Text(tag.content,
              style: Theme.of(context).textTheme.bodyText2!.apply(color: tag.color.toColor())),
        ],
      ),
    );
  }
}

class _GridTagLabel extends StatefulWidget {
  const _GridTagLabel({
    Key? key,
    required this.tags,
    required this.onTap,
  }) : super(key: key);

  final List<NotionTag> tags;
  final Function(NotionTag) onTap;

  @override
  State<_GridTagLabel> createState() => _GridTagLabelState();
}

class _GridTagLabelState extends State<_GridTagLabel> {
  NotionTag? _selectedTag;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: const EdgeInsets.all(8),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(16),
    //     color: Colors.grey[800],
    //   ),
    //   child: GridView.count(
    //     physics: const NeverScrollableScrollPhysics(),
    //     crossAxisCount: 3,
    //     children: tags.map((tag) => _TagLabel(tag: tag, onTap: onTap)).toList(),
    //   ),
    // );
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: widget.tags.length,
      itemBuilder: (context, index) {
        return _TagLabel(
          tag: widget.tags[index],
          onTap: (tag) {
            setState(() {
              _selectedTag = widget.tags[index];
            });
            widget.onTap(tag);
          },
          isSelected: _selectedTag == widget.tags[index],
        );
      },
    );
  }
}
