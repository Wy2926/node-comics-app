"""Open the local browser_filter_server.py /navigation page, then pass the Android device ID."""
import os
import re
import subprocess
import sys
import xml.etree.ElementTree as ET


def main(serial):
    def adb(*args):
        return subprocess.check_output(
            [os.environ.get('ADB', 'adb'), '-s', serial, *args], timeout=20)

    def document():
        data = adb('exec-out', 'uiautomator', 'dump', '/dev/tty')
        end = b'</hierarchy>'
        tree = ET.fromstring(data[data.index(b'<?xml'):data.index(end) + len(end)])
        for node in tree.iter('node'):
            if (node.get('class') == 'android.webkit.WebView' and
                    'Navigation fixture' in (node.get('text'), node.get('content-desc'))):
                return node
        raise AssertionError('Open the local /navigation fixture in the App browser')

    def label(doc, prefix):
        return next(n.get('text') for n in doc.iter('node') if n.get('text', '').startswith(prefix))

    for password in (False, True):
        doc = document()
        field = next(n for n in doc.iter('node') if n.get('class') == 'android.widget.EditText'
                     and (n.get('password') == 'true') == password)
        status = 'Password length: ' if password else 'Load '
        before = label(doc, status)
        assert before == 'Password length: 0' if password else before.endswith(' | empty'), \
            'Reload the test page with empty fields'
        left, top, right, bottom = map(int, re.findall(r'\d+', field.get('bounds')))
        adb('shell', 'input', 'tap', str((left + right) // 2), str((top + bottom) // 2))
        adb('shell', 'input', 'text', 'q')
        expected = 'Password length: 1' if password else before.removesuffix('empty') + 'q'
        assert label(document(), status) == expected, 'Text edit did not reach the document'
        assert b'mInputShown=true' in adb('shell', 'dumpsys', 'input_method'), 'IME did not open'
        adb('shell', 'input', 'keyevent', 'KEYCODE_DEL')
        assert label(document(), status) == before, 'Backspace did not reach the document'
        adb('shell', 'input', 'keyevent', 'KEYCODE_BACK')
        assert label(document(), status) == before, 'Dismissing the keyboard lost the page'
        assert b'mInputShown=false' in adb('shell', 'dumpsys', 'input_method'), 'IME still open'
    print('PASS: Android webpage text and password input, deletion and keyboard dismissal')


if __name__ == '__main__':
    main(sys.argv[1])
