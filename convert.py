import re

def wrap_title_braces(bib_content):
    """
    bibファイルのtitleフィールドに {} を二重で追加する関数
    """
    # title = {...} のパターンを探して {} を追加
    def replacer(match):
        original_title = match.group(1).strip()
        # すでに {} で囲まれている場合は何もしない
        if original_title.startswith('{') and original_title.endswith('}'):
            return f'title = {original_title}'
        # そうでなければ {{...}} にする
        return f'title = {{{{{original_title}}}}}'

    updated_content = re.sub(
        r'title\s*=\s*{(.*?)}',
        replacer,
        bib_content,
        flags=re.DOTALL
    )
    return updated_content

input_file = "ref_original.bib"
output_file = "ref.bib"

with open(input_file, encoding='utf-8') as f:
    bibdata = f.read()

modified_bibdata = wrap_title_braces(bibdata)

with open(output_file, 'w', encoding='utf-8') as f:
    f.write(modified_bibdata)

print(f"{output_file} に書き出しました。")
