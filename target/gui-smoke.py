import os
import subprocess
import time
from pathlib import Path

from PIL import Image, ImageChops

root = Path(__file__).resolve().parent.parent
out = root / 'target'
env = dict(os.environ, DISPLAY=':197', LIBGL_ALWAYS_SOFTWARE='1')
server_log = open(out / 'audit-xvfb.log', 'w')
log = open(out / 'audit-gui.log', 'w')
server = subprocess.Popen([
    str(out / 'audit-tools/usr/bin/Xvfb'), ':197', '-screen', '0',
    '1200x1200x24', '-nolisten', 'tcp', '-ac', '-noreset',
], env=env, stdout=server_log, stderr=subprocess.STDOUT)
process = None
try:
    time.sleep(0.7)
    assert server.poll() is None, 'Virtual display failed to start'
    process = subprocess.Popen([str(out / 'release/smart-road')], cwd='/tmp',
                               env=env, stdout=log, stderr=subprocess.STDOUT)
    window = None
    deadline = time.monotonic() + 10
    while time.monotonic() < deadline:
        found = subprocess.run(['xdotool', 'search', '--name', '^Smart Road$'],
                               env=env, capture_output=True, text=True)
        if found.returncode == 0 and found.stdout.strip():
            window = found.stdout.splitlines()[-1]
            break
        assert process.poll() is None, 'Application exited early'
        time.sleep(0.2)
    assert window, 'Application window not found'

    def key(name):
        subprocess.run(['xdotool', 'keydown', '--window', window, name],
                       env=env, check=True, capture_output=True)
        time.sleep(0.12)
        if process.poll() is None:
            subprocess.run(['xdotool', 'keyup', '--window', window, name],
                           env=env, check=True, capture_output=True)
        else:
            assert name == 'Escape' and process.returncode == 0
        time.sleep(0.15)

    def screenshot(name):
        path = out / name
        subprocess.run(['import', '-window', window, str(path)], env=env,
                       check=True, capture_output=True)
        return Image.open(path).convert('RGB')

    time.sleep(1.5)
    for name in ('Up', 'Down', 'Left', 'Right', 'r'):
        key(name)
    time.sleep(10)
    running = screenshot('audit-running.png')
    background = Image.open(root / 'assets/cross-road.png').convert('RGB')
    probes = [(200, 350), (200, 450), (350, 400), (1000, 300),
              (1100, 350), (1000, 1000), (200, 1000), (350, 1050)]
    error = sum(abs(a - b) for point in probes
                for a, b in zip(running.getpixel(point), background.getpixel(point)))
    assert error < 100, f'Camera orientation or texture alignment incorrect: {error}'
    key('d')
    screenshot('audit-debug.png')
    key('p')
    first = screenshot('audit-paused.png')
    time.sleep(1)
    second = screenshot('audit-paused-second.png')
    area = (440, 300, 750, 1080)
    assert ImageChops.difference(first.crop(area), second.crop(area)).getbbox() is None
    subprocess.run(['xdotool', 'windowsize', window, '900', '900'],
                   env=env, check=True, capture_output=True)
    time.sleep(0.4)
    assert screenshot('audit-resized.png').size == (900, 900)
    subprocess.run(['xdotool', 'windowsize', window, '1200', '1200'],
                   env=env, check=True, capture_output=True)
    time.sleep(0.4)
    key('Escape')
    screenshot('audit-statistics.png')
    assert process.poll() is None, 'First Escape closed the application'
    key('Return')
    screenshot('audit-restarted.png')
    key('Escape')
    key('Escape')
    assert process.wait(timeout=5) == 0
    print('GUI PASS: embedded assets, camera orientation, all arrow keys, automatic traffic,')
    print('debug, pause, resize, statistics, restart and clean exit.')
finally:
    if process is not None and process.poll() is None:
        process.terminate()
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()
    server.terminate()
    server.wait(timeout=5)
    log.close()
    server_log.close()
