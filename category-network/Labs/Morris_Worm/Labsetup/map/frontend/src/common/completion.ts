export interface CompletionTree {
    type:  'root' | 'keyword' | 'value';

    name?: string;
    description?: string;

    children?: CompletionTree[];
}

export interface CompletionOption {
    word: string;
    partialword: string;
    fulltext: string;
    description: string;
}

export class Completion {
    private _tree: CompletionTree;

    constructor(tree: CompletionTree) {
        this._tree = tree;
    }

    getCompletion(input: string): CompletionOption[] {
        let words = input.split(/\s+/);
        let lastWord = words.pop() ?? '';

        var pointer = this._tree;
        var fulltext: string[] = [];

        words.forEach(word => {
            fulltext.push(word);

            var nextPointer = this._tree;

            if (!pointer.children) {
                fulltext = [];
                pointer = this._tree;
                return;
            }

            pointer.children.forEach(child => {
                if (child.type == 'value') {
                    nextPointer = child;
                }

                if (child.type == 'keyword' && child.name === word) {
                    nextPointer = child;
                }
            });

            if (nextPointer == this._tree) {
                fulltext = [];
            }

            pointer = nextPointer;
        });

        if (pointer.children) {
            return pointer.children.filter(child => child.name.startsWith(lastWord)).map(child => {
                return {
                    word: child.name,
                    partialword: child.name.slice(lastWord.length),
                    fulltext: `${fulltext.join(' ')} ${child.name}`,
                    description: child.description
                };
            });
        }

        return [];
    }
}

