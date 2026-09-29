// Cuts ModIcon.png's background out for compositing onto Preview.png (owner's rule, 2026-09-29,
// see PUBLISHING.md "Toute galerie commence..." paragraph and ManyHappyReturns/Art/README.md for the
// reference technique). Flood-fills from the border inward, matching the border's own colour within a
// tight tolerance, so it never eats into the icon's own outline (which never touches the frame). This
// reads Mod/About/ModIcon.png (the owner's own delivered file) and only crops a copy: it never
// generates, retouches or replaces the icon itself (PUBLISHING.md, "Le ModIcon est generexclusivement
// par la proprietaire du mod").
const sharp = require('sharp');
const path = require('path');
const root = path.resolve(__dirname, '..');
(async () => {
  const src = path.join(root, 'Mod/About/ModIcon.png');
  const img = sharp(src).ensureAlpha();
  const { data, info } = await img.raw().toBuffer({ resolveWithObject: true });
  const { width: w, height: h, channels: c } = info;
  const [br, bg, bb] = [data[0], data[1], data[2]];
  const tol = 10;
  const isBg = i => Math.abs(data[i] - br) <= tol && Math.abs(data[i + 1] - bg) <= tol && Math.abs(data[i + 2] - bb) <= tol;
  const visited = new Uint8Array(w * h);
  const stack = [];
  for (let x = 0; x < w; x++) { stack.push([x, 0], [x, h - 1]); }
  for (let y = 0; y < h; y++) { stack.push([0, y], [w - 1, y]); }
  while (stack.length) {
    const [x, y] = stack.pop();
    if (x < 0 || y < 0 || x >= w || y >= h) continue;
    const p = y * w + x;
    if (visited[p]) continue;
    const i = p * c;
    if (!isBg(i)) continue;
    visited[p] = 1;
    data[i + 3] = 0;
    stack.push([x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]);
  }
  let removed = 0;
  for (let p = 0; p < w * h; p++) if (visited[p]) removed++;
  console.log(`background sampled at (${br},${bg},${bb}); removed ${removed} of ${w * h} pixels (${(100 * removed / (w * h)).toFixed(1)}%)`);
  if (removed === 0 || removed > 0.9 * w * h) throw new Error('Flood fill removed an implausible share of the icon: check the source.');
  await sharp(data, { raw: { width: w, height: h, channels: c } })
    .png({ compressionLevel: 9 })
    .toFile(path.join(root, 'Art/ModIcon-cutout.png'));
})();
