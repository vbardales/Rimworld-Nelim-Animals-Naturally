// Requires Node.js, playwright, sharp and installed Chrome. Run from any directory.
const fs=require('fs'),path=require('path'),http=require('http');
const {chromium}=require('playwright'),sharp=require('sharp');
const root=path.resolve(__dirname,'..');
const palette=JSON.parse(fs.readFileSync(path.join(__dirname,'preview-palette.json')));
function lum(rgb){return rgb.map(v=>{v/=255;return v<=.04045?v/12.92:((v+.055)/1.055)**2.4}).reduce((s,v,i)=>s+v*[.2126,.7152,.0722][i],0)}
function rgb(hex){return hex.match(/[a-f\d]{2}/gi).map(v=>parseInt(v,16))}
function contrast(a,b){return (Math.max(a,b)+.05)/(Math.min(a,b)+.05)}
(async()=>{
 const server=http.createServer((req,res)=>{const p=path.resolve(root,'.'+decodeURIComponent(req.url.split('?')[0]));if(!p.startsWith(root+path.sep)){res.writeHead(403).end();return;}fs.readFile(p,(e,b)=>{if(e){res.writeHead(404).end();return;}res.setHeader('Content-Type',p.endsWith('.png')?'image/png':p.endsWith('.json')?'application/json':p.endsWith('.xml')?'application/xml':'text/html');res.end(b);});});
 await new Promise(r=>server.listen(0,'127.0.0.1',r));
 let browser;
 try {
  browser=await chromium.launch({executablePath:process.env.CHROME_PATH||'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
  const page=await browser.newPage({viewport:{width:896,height:504},deviceScaleFactor:1});
  await page.goto(`http://127.0.0.1:${server.address().port}/Art/preview.html`);
  await page.evaluate(()=>window.previewReady);
  const cdp=await page.context().newCDPSession(page);await cdp.send('DOM.enable');await cdp.send('CSS.enable');
  const {root:doc}=await cdp.send('DOM.getDocument');
  const report={version:await page.locator('.version').innerText(),elements:{}};
  for(const selector of ['h1','.suffix','.tag','p','.version']){
   const {nodeId}=await cdp.send('DOM.querySelector',{nodeId:doc.nodeId,selector});
   const {fonts}=await cdp.send('CSS.getPlatformFontsForNode',{nodeId});
   report.elements[selector]={fonts,box:await page.locator(selector).boundingBox()};
   if(!fonts.length||fonts.some(f=>!/^Segoe UI(?: Semibold| Bold)?$/.test(f.familyName)))throw Error('Unexpected font '+JSON.stringify(fonts));
  }
  const out=path.join(root,'Mod/About/Preview.png');
  const png=await page.screenshot();await sharp(png).png({compressionLevel:9}).toFile(out);
  await sharp(png).resize(268).png().toFile(path.join(__dirname,'preview-268.png'));
  await page.addStyleTag({content:'.text {visibility:hidden} .version {visibility:hidden}'});
  const bg=await page.screenshot();await sharp(bg).png().toFile(path.join(__dirname,'preview-background.png'));
  const {data,info}=await sharp(bg).removeAlpha().raw().toBuffer({resolveWithObject:true});
  for(const [selector,e] of Object.entries(report.elements)){
   if(selector==='.version'){e.minContrast=contrast(lum(rgb(palette.badgeInk)),lum(rgb(palette.accent)));continue;}
   const ink=lum(rgb(['.tag','.suffix'].includes(selector)?palette.inkSecondary:palette.inkPrimary));let min=Infinity;
   const b=e.box;
   for(let y=Math.floor(b.y);y<Math.ceil(b.y+b.height);y++)for(let x=Math.floor(b.x);x<Math.ceil(b.x+b.width);x++){
    const i=(y*info.width+x)*info.channels;min=Math.min(min,contrast(ink,lum([...data.subarray(i,i+3)])));
   }
   e.minContrast=min;
  }
  report.bytes=fs.statSync(out).size;
  fs.writeFileSync(path.join(__dirname,'preview-qa.json'),JSON.stringify(report,null,2)+'\n');
  console.log(JSON.stringify(report,null,2));
  if(report.bytes>=900000||Object.values(report.elements).some(e=>e.minContrast<4.5))throw Error('Preview QA failed');
 } finally {if(browser)await browser.close();server.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
