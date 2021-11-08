
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex=0;
  var sumData=Summary();
  List<Regional> regionalData= List<Regional>();
  List<Regional> filtered =List<Regional>();
  bool _loading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    filtered=regionalData;
  }

  Future<void> getData() async{
    String url ="https://api.rootnet.in/covid19-in/stats/latest";

    var response= await http.get(url);
    debugPrint(response.body);
    var jsonData=jsonDecode(response.body);
    if (jsonData['success']==true) {
      var jData=jsonData['data'];
      var sum = jData['summary'];
      sumData = Summary(total: sum['total'],discharged: sum['discharged'],deaths: sum['deaths']);
      jData['regional'].forEach((element){
        Regional regional = Regional(
            loc: element['loc'],
            confirmedCasesIndian: element['confirmedCasesIndian'],
            deaths: element['deaths'],
            discharged: element['discharged']
        );
        regionalData.add(regional);
        setState(() {
          _loading=false;
        });
      });}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Covid-19 in India",textDirection: TextDirection.ltr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
        elevation: 0.0,
      ),

      body: _loading? Center(child:CircularProgressIndicator()): SingleChildScrollView(
        child: Container(
          height: 700,

          ///decoration: BoxDecoration(
             /// gradient: LinearGradient(
               ///   colors: [ Color(0xFFEEF8F2), Color(0xFFC1F1D4)],
                 /// begin: Alignment.topLeft,
               ///   end: Alignment.bottomRight
              ///)//
          ///),

          child: showScreen(_currentIndex)
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('All'),
            backgroundColor: Colors.blue
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('States'),
              backgroundColor: Colors.blue
          )
        ],
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        }

      ),


    );
  }
  Widget showScreen(int index){
    if (index==0){
    return showAll();
    }
    else
    {
      return showStates();
    }
  }
  Widget showStates()
  {
    return Stack(
      children: <Widget>[

        CachedNetworkImage(imageUrl:'https://image.freepik.com/free-vector/hand-drawn-map-india_23-2148208542.jpg', height: 800,width: 450,fit:BoxFit.cover),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: 375,
                height: 50,
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      hintText: 'Enter State Name', labelText: 'Enter State Name'),
                  onChanged: (string){
                    setState(() {
                      filtered=regionalData.where((u)=>(u.loc.toLowerCase().contains(string.toLowerCase()))).toList();
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 550,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: filtered.length,
                  itemBuilder: (context, index){
                    return RegionalBox(loc:filtered[index].loc, confirmedCasesIndian: filtered[index].confirmedCasesIndian.toString(),
                      deaths: filtered[index].deaths.toString(), discharged: filtered[index].discharged.toString(),
                    );
                  }
              ),
            ),
          ],
        ),
      ],

    );
  }
  Widget showAll()
  {
    return  Column(
        children:<Widget>[
    Container(child: OverallBox(total: sumData.total.toString(), discharged: sumData.discharged.toString(),deaths: sumData.deaths.toString())),
        Container(
          height: 70,
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepOrangeAccent
          ),
          margin: EdgeInsets.only(right:10,left: 10,bottom: 20),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[

                  Text("Clean your hands often", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),),

              Padding(
                padding: EdgeInsets.only(top:5,bottom: 5),
                  child: Image.network('https://www.cdc.gov/coronavirus/2019-ncov/images/protect-wash-hands.png'))
            ],
          )
        ),
          Container(
              height: 70,
              width: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepOrangeAccent
              ),
              margin: EdgeInsets.only(right:10,left: 10,bottom: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Text("Avoid close contact", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),),

                  Padding(
                      padding: EdgeInsets.only(top:5,bottom: 5),
                      child: Image.network('https://www.cdc.gov/coronavirus/2019-ncov/images/protect-quarantine.png'))
                ],
              )
          ),

          Container(
              height: 70,
              width: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepOrangeAccent
              ),
              margin: EdgeInsets.only(right:10,left: 10,bottom: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Text("Cover your mouth and nose "
                      "\n with a cloth face cover \n when around others", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white,
                  ), textDirection: TextDirection.ltr,),

                  Padding(
                      padding: EdgeInsets.only(top:5,bottom: 5),
                      child: Image.network('https://www.cdc.gov/coronavirus/2019-ncov/images/prevent-getting-sick/cloth-face-cover.png'))
                ],
              )
          ),
          Container(
              height: 70,
              width: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepOrangeAccent
              ),
              margin: EdgeInsets.only(right:10,left: 10,bottom: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Text("Cover coughs and sneezes", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),),

                  Padding(
                      padding: EdgeInsets.only(top:5,bottom: 5),
                      child: Image.network('https://www.cdc.gov/coronavirus/2019-ncov/images/COVIDweb_06_coverCough.png'))
                ],
              )
          ),
          Container(
              height: 70,
              width: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepOrangeAccent
              ),
              margin: EdgeInsets.only(right:10,left: 10,bottom: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Text("Clean and disinfect", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),),

                  Padding(
                      padding: EdgeInsets.only(top:5,bottom: 5),
                      child: Image.network('https://www.cdc.gov/coronavirus/2019-ncov/images/COVIDweb_09_clean.png'))
                ],
              )
          ),


        ]
    );
  }
}

class RegionalBox extends StatelessWidget {
  final String loc;
  final String confirmedCasesIndian;
  final String discharged;
  final String deaths;
  RegionalBox({this.loc, this.confirmedCasesIndian, this.discharged, this.deaths});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 300,

      margin: EdgeInsets.only(top:100, left: 35, right: 10,bottom: 50),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFCA887 ),
              blurRadius: 10.0, // soften the shadow
              spreadRadius: 2.0, //extend the shadow
              offset: Offset(
                10.0, // Move to right 10  horizontally
                10.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        gradient: LinearGradient(
          colors: [ Color(0xFFF54747 ), Color(0xFFFCA887 )],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        ),
          borderRadius: BorderRadius.circular(25)),

    child:Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(child: Text(loc, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Cases", style: TextStyle(fontSize:17, fontWeight: FontWeight.w500 ),),
              Text ("$confirmedCasesIndian", style: TextStyle(fontSize:30, fontWeight: FontWeight.w900, color: Colors.white )),
            ],
          ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Deaths",style: TextStyle(fontSize:17, fontWeight: FontWeight.w500)),
                Text("$deaths",style: TextStyle(fontSize:30, fontWeight: FontWeight.w700, color:Colors.white )),
              ],
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Discharged",style: TextStyle(fontSize:17, fontWeight: FontWeight.w500)),
              Text("$discharged",style: TextStyle(fontSize:30, fontWeight: FontWeight.w700, color:Colors.white ))

            ],
          )

        ],
      )
    );
  }
}
class OverallBox extends StatelessWidget {
  final total,discharged, deaths;
  OverallBox({this.total,this.discharged,this.deaths});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
        margin: EdgeInsets.only(top:20, left: 30, right: 30,bottom: 20),
        height: 150,
        width: 350,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ Color(0xFFF54747 ), Color(0xFFFCA887 )],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            ),
          borderRadius: BorderRadius.circular(25),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white)),
                  Text('$total',style: TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.w700))
                ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Discharged: $discharged",style:TextStyle(color:Colors.white,fontSize: 17)),
                Text("Deaths: $deaths", style: TextStyle(color: Colors.white,fontSize: 17))
              ],
            )
          ],
        )
    );
  }
}




class Summary{
  var total;
  var discharged;
  var deaths;
  Summary({this.total, this.discharged, this.deaths});

}

class Regional{
  var loc;
  var confirmedCasesIndian;
  var discharged;
  var deaths;
  Regional({this.loc, this.confirmedCasesIndian, this.discharged, this.deaths});
}


