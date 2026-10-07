import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const BabaMleziApp());

class BabaMleziApp extends StatefulWidget {
  const BabaMleziApp({super.key});
  @override State<BabaMleziApp> createState() => _BabaMleziAppState();
}
class _BabaMleziAppState extends State<BabaMleziApp> {
  bool sw = true;
  void toggle() => setState(() => sw = !sw);
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Baba Mlezi',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff137a52)), useMaterial3: true),
    home: HomePage(sw: sw, toggle: toggle),
  );
}

class HomePage extends StatefulWidget {
  final bool sw; final VoidCallback toggle;
  const HomePage({super.key, required this.sw, required this.toggle});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int tab=0;
  @override Widget build(BuildContext context) {
    final pages=[HomeBody(sw:widget.sw, openAi:()=>setState(()=>tab=2)), const LibraryPage(), AiPage(sw:widget.sw), SettingsPage(sw:widget.sw,toggle:widget.toggle)];
    return Scaffold(
      appBar: AppBar(title: const Text('Baba Mlezi', style: TextStyle(fontWeight: FontWeight.w800)), actions:[TextButton(onPressed:widget.toggle, child:Text(widget.sw?'EN':'SW'))]),
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),destinations:[
        NavigationDestination(icon:const Icon(Icons.home_outlined),selectedIcon:const Icon(Icons.home),label:widget.sw?'Nyumbani':'Home'),
        NavigationDestination(icon:const Icon(Icons.menu_book_outlined),label:widget.sw?'Maktaba':'Library'),
        const NavigationDestination(icon:Icon(Icons.auto_awesome),label:'Mlezi AI'),
        NavigationDestination(icon:const Icon(Icons.settings_outlined),label:widget.sw?'Mipangilio':'Settings'),
      ]),
    );
  }
}

class HomeBody extends StatelessWidget {
  final bool sw; final VoidCallback openAi;
  const HomeBody({super.key,required this.sw,required this.openAi});
  @override Widget build(BuildContext context) => ListView(padding:const EdgeInsets.all(18),children:[
    Center(child:Image.asset('assets/images/baba_mlezi_logo.png',height:115,fit:BoxFit.contain)),
    const SizedBox(height:8),
    Text(sw?'Kulea kwa maarifa, kujenga kesho bora.':'Raising children with knowledge and care.',textAlign:TextAlign.center,style:Theme.of(context).textTheme.titleMedium),
    const SizedBox(height:20),
    Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(sw?'Ushauri wa leo':'Today’s parenting tip',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.bold)),
      const SizedBox(height:8),Text(sw?'Mtoto hujifunza zaidi anapohisi kusikilizwa. Tenga muda wa kuzungumza naye bila simu au usumbufu.':'Children learn better when they feel heard. Set aside distraction-free time to talk with them.')
    ]))),
    const SizedBox(height:18),Text(sw?'Chagua umri wa mtoto':'Choose child age',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.bold)),
    const SizedBox(height:10),Wrap(spacing:10,runSpacing:10,children:['0–2','3–5','6–12','13–18'].map((a)=>ActionChip(avatar:const Icon(Icons.child_care),label:Text('$a ${sw?'miaka':'years'}'),onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>AgePage(age:a,sw:sw))))).toList()),
    const SizedBox(height:20),FilledButton.icon(onPressed:openAi,icon:const Icon(Icons.auto_awesome),label:Text(sw?'Uliza Baba Mlezi AI':'Ask Baba Mlezi AI'),style:FilledButton.styleFrom(padding:const EdgeInsets.all(16))),
    const SizedBox(height:18),Text(sw?'Mada maarufu':'Popular topics',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.bold)),
    ...topics(sw).map((t)=>Card(child:ListTile(leading:Icon(t.$3),title:Text(t.$1),subtitle:Text(t.$2),trailing:const Icon(Icons.chevron_right))))
  ]);
}

List<(String,String,IconData)> topics(bool sw)=> sw ? [
  ('Nidhamu chanya','Mipaka yenye upendo bila ukatili',Icons.favorite_outline),('Elimu na kusoma','Jenga tabia nzuri ya kujifunza',Icons.school_outlined),('Afya ya akili','Tambua hisia na mabadiliko ya mtoto',Icons.psychology_outlined),('Usalama mtandaoni','Linda mtoto katika ulimwengu wa kidijitali',Icons.shield_outlined)
] : [
  ('Positive discipline','Loving boundaries without violence',Icons.favorite_outline),('Learning','Build healthy study habits',Icons.school_outlined),('Mental wellbeing','Understand feelings and behavior changes',Icons.psychology_outlined),('Online safety','Protect children in the digital world',Icons.shield_outlined)
];

class AgePage extends StatelessWidget {
  final String age; final bool sw; const AgePage({super.key,required this.age,required this.sw});
  @override Widget build(BuildContext context){final items=topics(sw);return Scaffold(appBar:AppBar(title:Text('$age ${sw?'miaka':'years'}')),body:ListView(padding:const EdgeInsets.all(16),children:[Text(sw?'Mwongozo wa maendeleo, elimu na malezi':'Development, education & parenting guide',style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:12),...items.map((x)=>Card(child:ListTile(leading:Icon(x.$3),title:Text(x.$1),subtitle:Text(x.$2))))]));}
}

class LibraryPage extends StatelessWidget { const LibraryPage({super.key}); @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[Text('Library / Maktaba',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),const SizedBox(height:12),for(final x in ['Positive discipline / Nidhamu chanya','School readiness / Maandalizi ya shule','Teen communication / Mawasiliano na kijana','Digital safety / Usalama mtandaoni']) Card(child:ListTile(leading:const Icon(Icons.article_outlined),title:Text(x),subtitle:const Text('Article • 5 min'),trailing:const Icon(Icons.bookmark_border))) ]); }

class AiPage extends StatefulWidget { final bool sw; const AiPage({super.key,required this.sw}); @override State<AiPage> createState()=>_AiPageState(); }
class _AiPageState extends State<AiPage>{
  final c=TextEditingController(); final msgs=<Map<String,String>>[]; bool loading=false;
  static const endpoint=String.fromEnvironment('BABA_MLEZI_AI_URL',defaultValue:'');
  Future<void> send() async { final q=c.text.trim(); if(q.isEmpty||loading)return; setState((){msgs.add({'role':'user','text':q});loading=true;c.clear();}); String answer;
    try { if(endpoint.isEmpty){answer=widget.sw?'Demo ya AI: Nimepokea swali lako. Katika toleo lililounganishwa, nitatoa mwongozo unaolingana na umri wa mtoto, hatua salama za kujaribu, na dalili zinazohitaji mtaalamu. Kwa dharura, tafuta huduma za dharura mara moja.':'AI demo: I received your question. Once connected, I will provide age-appropriate guidance, safe steps to try, and signs that require professional help. For emergencies, seek emergency care immediately.';} else {final r=await http.post(Uri.parse(endpoint),headers:{'Content-Type':'application/json'},body:jsonEncode({'message':q,'language':widget.sw?'sw':'en'})); if(r.statusCode<200||r.statusCode>=300) throw Exception('HTTP ${r.statusCode}'); final d=jsonDecode(r.body);answer=(d['answer']??d['message']??'').toString(); if(answer.isEmpty)throw Exception('Empty response');}}
    catch(_){answer=widget.sw?'Samahani, huduma ya AI haipatikani sasa. Jaribu tena baadaye.':'Sorry, AI service is unavailable right now. Please try again later.';} setState((){msgs.add({'role':'assistant','text':answer});loading=false;}); }
  @override Widget build(BuildContext context)=>Column(children:[Container(width:double.infinity,padding:const EdgeInsets.all(14),color:Theme.of(context).colorScheme.secondaryContainer,child:Text(widget.sw?'Baba Mlezi AI hutoa mwongozo wa jumla, si uchunguzi wa kitabibu.':'Baba Mlezi AI provides general guidance, not medical diagnosis.')),Expanded(child:msgs.isEmpty?Center(child:Padding(padding:const EdgeInsets.all(28),child:Text(widget.sw?'Uliza kuhusu elimu, tabia, maendeleo au malezi ya mtoto wa miaka 0–18.':'Ask about education, behavior, development or parenting for ages 0–18.',textAlign:TextAlign.center))):ListView.builder(padding:const EdgeInsets.all(12),itemCount:msgs.length,itemBuilder:(_,i){final m=msgs[i],u=m['role']=='user';return Align(alignment:u?Alignment.centerRight:Alignment.centerLeft,child:Card(child:Padding(padding:const EdgeInsets.all(12),child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:310),child:Text(m['text']!)))));})),Padding(padding:const EdgeInsets.all(12),child:Row(children:[Expanded(child:TextField(controller:c,onSubmitted:(_)=>send(),decoration:InputDecoration(hintText:widget.sw?'Andika swali lako...':'Type your question...',border:const OutlineInputBorder()))),const SizedBox(width:8),IconButton.filled(onPressed:loading?null:send,icon:loading?const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.send))]))]);
}

class SettingsPage extends StatelessWidget { final bool sw; final VoidCallback toggle; const SettingsPage({super.key,required this.sw,required this.toggle}); @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[Text(sw?'Mipangilio':'Settings',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),SwitchListTile(value:sw,onChanged:(_)=>toggle(),title:Text(sw?'Kiswahili':'Swahili'),subtitle:const Text('Kiswahili / English')),const ListTile(leading:Icon(Icons.privacy_tip_outlined),title:Text('Privacy & Safety')),const ListTile(leading:Icon(Icons.info_outline),title:Text('Baba Mlezi v1.0 Beta'))]); }
