import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EWasteBotScreen extends StatefulWidget {
  @override
  _EWasteBotScreenState createState() => _EWasteBotScreenState();
}

class _EWasteBotScreenState extends State<EWasteBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = []; // Stores conversation history
  final ScrollController _scrollController = ScrollController(); // ScrollController to manage scrolling

  @override
  void initState() {
    super.initState();
    // Add an initial default message from the bot when the screen loads
    _messages.add({"bot": "Hello! Welcome to the E-Waste Bot.\nAsk me anything about e-waste, recycling centers, and how to recycle different electronics. I'll be happy to help!"});
  }
  // Function to scroll to the bottom of the list view
  // Function to scroll to the start of the bot's response
  void _scrollToBotResponse() {
    // Wait for the message to be rendered, then scroll to the start of the bot's response
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, // Scroll to the end of the list to reveal the bot's response
          duration: Duration(milliseconds: 300), // Duration for the scroll
          curve: Curves.easeOut, // Smooth scroll effect
        );
      }
    });
  }
  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({"user": message});
        // Handling the nullable response by using '??' for a default value
        String botResponse = _generateBotResponse(message) ?? "I didn't quite understand that. Could you ask something else related to e-waste or recycling?";
        _messages.add({"bot": botResponse});
      });
      _messageController.clear();
      _scrollToBotResponse(); // Automatically scroll to the bottom after sending a message
    }
  }

  String? _generateBotResponse(String userMessage) {
    // Convert the user message to lowercase for case-insensitive comparison
    String message = userMessage.toLowerCase();

    // Simple bot logic for e-waste-related queries
    if (message.contains("hi") || message.contains("hello") || message.contains("hey")) {
      return "Hello! How can I assist you today? Feel free to ask me about e-waste or related topics.";
    }else if (message.contains("bye") || message.contains("goodbye") || message.contains("see you")) {
      return "Goodbye! Have a great day! Feel free to return if you have more questions about e-waste or anything else.";
    }else if (message.contains("thank you") ||
        message.contains("thanks") ||
        message.contains("thank you so much") ||
        message.contains("thanks a lot") ||
        message.contains("thanks!") ||
        message.contains("thank you!")) {
      return "You're welcome! If you have more questions, feel free to ask.";
    }else if (message.contains("tell me more") ||
        message.contains("tell me about")||
        message.contains("tell me in detail") ||
        message.contains("more about") ||
        message.contains("details on") ||
        message.contains("detail") ||
        message.contains("tell me more about")) {
      if (message.contains("e waste recycling")||message.contains("recycling")||message.contains("e-waste recycling")||message.contains("ewaste")) {
        return "E-waste recycling is the process of recovering valuable materials from old electronics, such as metals and plastics, while safely disposing of hazardous substances. It helps conserve natural resources, reduces pollution, and minimizes the amount of waste in landfills. The process typically involves disassembling devices, sorting materials, and then recycling them into raw materials for new products.";
      } else if (message.contains("urban mining")) {
        return "Urban mining refers to the process of extracting valuable metals and materials from discarded electronic devices, such as gold, silver, copper, and rare earth metals. Unlike traditional mining, which depletes natural resources, urban mining helps recover materials that can be reused, reducing the need for new mining and its associated environmental impacts.";
      } else if (message.contains("e-waste management")||message.contains("e waste management")) {
        return "E-waste management involves collecting, recycling, and safely disposing of electronic waste. It focuses on reducing the environmental impact of e-waste by encouraging responsible disposal methods. Governments and organizations implement regulations to ensure e-waste is processed in a safe manner that prevents contamination of air, water, and soil with harmful chemicals.";
      } else if (message.contains("e-waste laws in india")||message.contains("e waste laws in india")) {
        return "India has the E-Waste (Management) Rules, 2016, which lay out the responsibilities of producers, consumers, and recyclers to manage e-waste. These rules mandate extended producer responsibility (EPR), ensure collection and recycling targets are met, and promote awareness about the harmful impacts of improper e-waste disposal.";
      } else {
        return "Can you please specify the topic you'd like more details on? I can provide more information on e-waste, recycling, urban mining, and more!";
      }
    }  else if (message.contains("e waste recycling")||message.contains("recycling")||message.contains("e-waste recycling")) {
      return "E-waste recycling is the process of recovering valuable materials from old electronics, such as metals and plastics, while safely disposing of hazardous substances. It helps conserve natural resources, reduces pollution, and minimizes the amount of waste in landfills. The process typically involves disassembling devices, sorting materials, and then recycling them into raw materials for new products.";
    } else if (message.contains("urban mining")) {
      return "Urban mining refers to the process of extracting valuable metals and materials from discarded electronic devices, such as gold, silver, copper, and rare earth metals. Unlike traditional mining, which depletes natural resources, urban mining helps recover materials that can be reused, reducing the need for new mining and its associated environmental impacts.";
    } else if (message.contains("e-waste management")||message.contains("e waste management")) {
      return "E-waste management involves collecting, recycling, and safely disposing of electronic waste. It focuses on reducing the environmental impact of e-waste by encouraging responsible disposal methods. Governments and organizations implement regulations to ensure e-waste is processed in a safe manner that prevents contamination of air, water, and soil with harmful chemicals.";
    } else if (message.contains("e-waste laws in india")||message.contains("e waste laws in india")) {
      return "India has the E-Waste (Management) Rules, 2016, which lay out the responsibilities of producers, consumers, and recyclers to manage e-waste. These rules mandate extended producer responsibility (EPR), ensure collection and recycling targets are met, and promote awareness about the harmful impacts of improper e-waste disposal.";
    }else if (message.contains("types of e-waste")||message.contains("types of ewaste")) {
      return "E-waste includes discarded electronic devices such as household appliances, consumer electronics, IT equipment, medical devices, and lighting devices.";
    } else if (message.contains("why is e-waste a growing problem")||message.contains("why is e waste a growing problem")) {
      return "E-waste is growing due to rapid technological advancement, increased consumer demand, improper disposal, and toxic components like lead and mercury.";
    } else if (message.contains("steps in e-waste recycling")||message.contains("steps in ewaste recycling")) {
      return "E-waste recycling involves collection, dismantling, separation, material processing, and safe disposal of non-recyclable parts.";
    } else if (message.contains("how to reduce e-waste")||message.contains("how to reduce e waste")||message.contains("reduce e waste")||message.contains("reduce e-waste")) {
      return "Reduce e-waste by reusing and repairing devices, donating to NGOs or schools, recycling at certified centers, and buying refurbished devices.";
    } else if (message.contains("e-waste laws in india")||message.contains("e waste laws in india")||message.contains("ewaste laws in india")) {
      return "India's E-Waste Management Rules, 2016 mandate extended producer responsibility (EPR), collection targets, and certified recycling facilities.";
    } else if (message.contains("e-waste and human health")||message.contains("e waste and human health")) {
      return "Improper disposal of e-waste releases toxic chemicals like lead and cadmium, causing brain, kidney, and respiratory issues.";
    } else if (message.contains("government role in e-waste management")||message.contains("government role in e waste management")) {
      return "Governments enforce e-waste laws, promote awareness, establish recycling centers, and incentivize sustainable practices.";
    } else if (message.contains("valuable materials from e-waste")||message.contains("valuable materials from e waste")) {
      return "E-waste contains valuable materials like gold, silver, copper, aluminum, and rare earth metals, which can be recovered through recycling.";
    } else if (message.contains("challenges in e-waste management")||message.contains("challenges in e waste management")) {
      return "Challenges include lack of awareness, illegal dumping, high recycling costs, low collection rates, and limited recycling facilities.";
    } else if (message.contains("innovations in e-waste recycling")||message.contains("innovations in e waste recycling")) {
      return "Innovations include robotic dismantling systems, chemical recycling methods, blockchain tracking for transparency, and urban mining.";
    } else if (message.contains("harm")) {
      return "Improper disposal of e-waste can release toxic chemicals, harming soil and water.";
    }else if (message.contains("e-waste calculator")) {
      return "The e-waste recycling rates per kilogram are: \n- Mobile: ₹400\n- Laptop: ₹600\n- Circuit Board: ₹1000\n- Battery: ₹250\n- Plastic: ₹50\n- Metal: ₹300";
    }   else if (userMessage.contains("what is electronic recycling")) {
      return "Electronic recycling involves reprocessing electronic waste into reusable materials, reducing landfill waste.";
    } else if (userMessage.contains("why recycle electronics")) {
      return "Recycling electronics conserves natural resources and prevents harmful chemicals from polluting the environment.";
    } else if (userMessage.contains("can all electronics be recycled")) {
      return "Not all electronics can be recycled. Check with local facilities to know what items they accept.";
    } else if (userMessage.contains("what happens to recycled e-waste")) {
      return "Recycled e-waste is dismantled, sorted, and processed into raw materials for manufacturing.";
    } else if (userMessage.contains("what is urban mining")) {
      return "Urban mining refers to extracting valuable metals from e-waste instead of mining new resources.";
    } else if (userMessage.contains("can i sell old electronics")) {
      return "Yes, many organizations and recycling programs buy old electronics for reuse or recycling.";
    } else if (userMessage.contains("is e-waste hazardous")) {
      return "Yes, e-waste can be hazardous due to the presence of toxic substances like lead and mercury.";
    } else if (userMessage.contains("what is e-waste management")) {
      return "E-waste management involves collecting, recycling, and safely disposing of electronic waste.";
    } else if (userMessage.contains("can i donate old electronics")) {
      return "Yes, donating old electronics to charities or schools is a great way to extend their lifespan.";
    } else if(message.contains("ewaste")||message.contains("e-waste")||message.contains("e waste")){
      return "E-waste (electronic waste) refers to discarded electronic devices like computers, smartphones, TVs, and batteries that are no longer in use or functioning.";
    }else if (userMessage.contains("does e-waste pollute air")) {
      return "Improper e-waste disposal can release harmful fumes, polluting the air and affecting health.";
    }else if (message.contains("recycle")) {
      return "You can recycle e-waste at certified centers. Avoid dumping electronics in regular trash.";
    } else if (message.contains("harm")) {
      return "Improper disposal of e-waste can release toxic chemicals, harming soil and water.";
    } else if (message==("recycling centers")||message==("recycling centers in")) {
      return "Please provide your district to find nearby e-waste recycling centers.";
    } else if (message.contains("laptop")) {
      return "Step 1: Disassemble the laptop by removing components like the battery, motherboard, screen, and casing.\nStep 2: Extract precious metals such as gold and copper from the circuit boards.\nStep 3: Recycle plastics and other materials for reuse.\nLaptops are disassembled to recycle components like batteries, motherboards, screens, and casings.\nPrecious metals like gold and copper are also extracted.";
    } else if (message.contains("smartphone")) {
      return "Step 1: Remove the battery and any removable parts.\nStep 2: Shred the smartphone and extract metals from the circuit boards.\nStep 3: Recycle the plastic and glass components.\nSmartphones are recycled by removing batteries, shredding SIM cards, and recovering metals from circuit boards.";
    } else if (message.contains("television")) {
      return "Step 1: Dismantle the TV into its parts like the screen, motherboard, and casing.\nStep 2: For CRT TVs, safely handle the lead and mercury, while for flat-screens, recover metals and glass.\nStep 3: Recycle the plastic and metals for reuse.\nCRT TVs and flat-screen TVs are processed separately to recover metals, glass, and other materials.\nLead and mercury are handled carefully.";
    } else if (message.contains("printer")) {
      return "Step 1: Dismantle the printer into cartridges, plastic casings, and electronic components.\nStep 2: Recover materials like plastics, metals, and electronic parts for recycling.\nPrinters are dismantled into cartridges, plastic casings, and electronic components for material recovery.";
    } else if (message.contains("gaming console")) {
      return "Step 1: Open the console and extract the internal components such as the circuit board and hard drive.\nStep 2: Recover metals from the internal components.\nStep 3: Reuse plastic shells for other products.\nGaming consoles are recycled by extracting metals from internal components and reusing plastic shells.";
    } else if (message.contains("battery")) {
      return "Step 1: Sort the batteries by type (e.g., lithium, nickel, lead-acid).\nStep 2: Crush the batteries to recover metals like lithium and cobalt.\nStep 3: Recycle the remaining materials for reuse.\nBatteries are sorted by type and crushed to recover metals like lithium and cobalt.";
    } else if (message.contains("cable") || message.contains("charger")||message.contains("cables") ||message.contains("chargers") ) {
      return "Step 1: Shred the cables and chargers to separate copper wires from plastic coverings.\nStep 2: Recover the copper and other recyclable materials.\nStep 3: Recycle the plastic covering for use in new products.\nCables and chargers are shredded to separate copper wires and plastic coverings for reuse.";
    } else if (message.contains("hard drive")) {
      return "Step 1: Shred the hard drive to ensure data destruction.\nStep 2: Recover materials like aluminum and rare earth magnets from the components.\nStep 3: Recycle the remaining materials for use in new products.\nHard drives are shredded to ensure data destruction, and materials like aluminum and rare earth magnets are recovered.";
    } else if (message.contains("keyboard")) {
      return "Step 1: Dismantle the keyboard to separate the plastics, wires, and circuit boards.\nStep 2: Recycle the plastics and metals for reuse.\nStep 3: Separate and recycle electronic components like microchips.\nKeyboards are dismantled to recycle plastics, wires, and circuit boards.";
    } else if (message.contains("router") || message.contains("modem")) {
      return "Step 1: Dismantle the router or modem to separate the plastics, metals, and electronic components.\nStep 2: Recycle the plastic and metal parts.\nStep 3: Recover valuable electronic components for reuse.\nRouters and modems are dismantled to recycle plastics, metals, and electronic components.";
    } else if (message.contains("microwave")) {
      return "Step 1: Dismantle the microwave to separate parts like the metal casing, magnetron, and plastic components.\nStep 2: Recover metals such as steel and aluminum.\nStep 3: Recycle the plastic and other materials.\nMicrowaves are dismantled to recover metals like steel and aluminum, along with recyclable plastics.";
    } else if (message.contains("refrigerator")) {
      return "Step 1: Safely remove refrigerants from the refrigerator.\nStep 2: Dismantle the components and separate metals, plastics, and insulation.\nStep 3: Recycle the metals and repurpose the plastic insulation.\nRefrigerators are processed to safely remove refrigerants, recycle metals, and repurpose plastic insulation.";
    } else if (message.contains("camera")) {
      return "Step 1: Dismantle the camera to separate plastics, metals, and electronic components.\nStep 2: Recover valuable metals and components for reuse.\nStep 3: Recycle the remaining materials for future products.\nCameras are recycled by separating plastics, metals, and electronic components for material recovery.";
    } else if (message.contains("smart home device")) {
      return "Step 1: Dismantle the smart home device to separate plastics, metals, and circuit boards.\nStep 2: Recover valuable components for reuse.\nStep 3: Recycle the plastics and metals for future products.\nSmart home devices are dismantled to recycle plastics, metals, and circuit boards.";
    } else if (message==("e-waste")||message==("e waste")) {
      return "E-waste refers to discarded electronic devices. Recycling helps reduce environmental harm!";
    }else if (message.contains("solar panel")) {
      return "Step 1: Dismantle the solar panel to separate glass, silicon, and metals.\nStep 2: Recover valuable materials like aluminum and silicon for reuse.\nStep 3: Recycle the remaining components.\nSolar panels are recycled to recover glass, silicon, and metals like aluminum.";
    }else if(message=="madurai"){
      return _getRecyclingCenters("madurai");
    }else if(message=="chennai"){
      return _getRecyclingCenters("chennai");
    }else if(message=="coimbatore"){
      return _getRecyclingCenters("coimbatore");
    }else if(message=="kancheepuram"){
      return _getRecyclingCenters("kancheepuram");
    }else if(message=="chengalpattu"){
      return _getRecyclingCenters("chengalpattu");
    }else if(message=="trichy"){
      return _getRecyclingCenters("trichy");
    }else if(message=="tiruvallur"){
      return _getRecyclingCenters("tiruvallur");
    }
    // Extract district name and fetch recycling center information
    RegExp districtPattern = RegExp(r"(?:centers in|e-waste centers in|recycling centers in) ([a-zA-Z\s]+)");
    RegExpMatch? match = districtPattern.firstMatch(message);

    if (match != null) {
      String district = match.group(1)?.trim() ?? "";
      String? response = _getRecyclingCenters(district);
      if (response != null) {
        return response;
      } else {
        return "Sorry, I couldn't find any recycling centers in $district. Please try another district.";
      }
    }

    // Default response for other questions
    return "I'm here to help with any questions about e-waste! Please ask anything.";
  }

  String? _getRecyclingCenters(String district) {
    // Mapping district to relevant recycling centers
    // List of e-waste centers based on district
    Map<String, List<Map<String, String>>> recyclingCenters = {
      "chennai": [
        {
          "name": "M/s A.K. Enterprises",
          "address": "No:12, Chakarapani Street, Velacherry, Chennai – 600032",
          "contact": "9176664862",
          "email": "akenter06@gmail.com"
        },
        {
          "name": "M/s Abishek Enterprises",
          "address": "SF No. 2G, North Phase, Ambattur, Chennai – 600098",
          "contact": "9884057878",
          "email": "enterprisesabishek@gmail.com"
        },
        {
          "name": "M/s AER Worldwide India Pvt Ltd",
          "address": "SF No.774, Elandandheri, Sadayankuppam village, Manali New Town, Chennai – 600103",
          "contact": "9940105999",
          "email": "jkumar@aerworldwide.com, akaja@aerworld.com"
        },
        {
          "name": "M/s Arockia Enterprises",
          "address": "S.F.No.4/1E, Seevaram village, Sholinganallur taluk, Chennai – 600097",
          "contact": "9551044431",
          "email": "associates.grid@gmail.com"
        }
      ],
      "chengalpattu":[
        {
          "name": "M/s Blooming Recyclers",
          "address": "Plot. No. D9/2, SIDCO Industrial Estate, Maraimalai Nagar, Kizhikaranai village, Chengalpattu district",
          "contact": "9840160149",
          "email": "bloomingrecycles@gmail.com"
        },
        {
          "name": "M/s Earth Sense Recycle Private Limited",
          "address": "SF No. 247, Thenmelpakkam village, Chengalpattu taluk, Chengalpattu district",
          "contact": "9962222459",
          "email": "ewastechennai@earthsense.in"
        },
        {
          "name": "M/s E PROCESS House c/o Bharat Electronics Limited",
          "address": "SF No 3 & 10/1 Nanthambakkam village, Alandur taluk, Chengalpattu district",
          "contact": "--",
          "email": "--"
        },
        {
          "name": "M/s Enviro Green E-waste Recycling Solutions",
          "address": "SF No. 2134, Palur village, Chengalpattu taluk, Chengalpattu district",
          "contact": "9445050342",
          "email": "envirogreenewaste@gmail.com"
        },
        {
          "name": "M/s Leela Traders",
          "address": "SF No. 41/1 part, Cuddaloor village, Chengalpattu taluk, Chengalpattu district",
          "contact": "9380888877",
          "email": "info@leelatraders.co.in, v.kumaran@hotmail.com"
        }
      ],
      "coimbatore": [
        {
          "name": "ZEB CARE (Coimbatore)",
          "address": "47/D, Valli Towers, First Floor, Radhakrishna Road, Opp to Karuna Suzuki, Tatabad, Coimbatore, Tamil Nadu - 641012",
          "contact": "04223504727",
          "email": "coimbatore.service@zebcare.in"
        },
        {
          "name": "M/s. Green Era Recyclers",
          "address": "SF No. 344/2, Kavundampalayam village, Coimbatore North taluk, Coimbatore district – 641025",
          "contact": "9965664526, 8300223526",
          "email": "prasanth@thegreenera.in"
        },
        {
          "name": "M/s. Green India Recyclers",
          "address": "SF No. 26/1B, Kovilpalayam road, Soolakkal village, Kinathukadavu taluk, Coimbatore – 642110",
          "contact": "9003491034, 9894940304",
          "email": "info@greenindiarecyclers.com"
        },
        {
          "name": "Tharani Electronics Waste",
          "address": "1b, P M Swamy Colony, Rathinapuri, Coimbatore",
          "contact": "9171450039",
          "email": "tharaniewast00@gmail.com, tharaniewast100@gmail.com"
        }
      ],
      "madurai":[
        {
          "name": "ZEB CARE (Madurai)",
          "address": "30 First Floor, Krishnarayar Tank Street, Near Hanuman Temple, Madurai, Tamil Nadu - 625001",
          "contact": "0452-4377340, 9944861446",
          "email": "madurai.service@zebcare.in"
        },
        {
          "name": "Rajapandi Waste Paper Store",
          "address": "126A, Kamatchi Nagar, Vilangudi, Madurai",
          "contact": "092457 39706"
        },
        {
          "name": "Sri Balaji Waste Paper Store",
          "address": "155, Chitrakkara Street, Keelavasal, Madurai Main, Madurai",
          "contact": "093452 09725"
        },
        {
          "name": "Sri Annamalaiyar Waste Paper Store",
          "address": "123-206, East Perumal Maistry Street, Chithirakara Street, Madurai"
        },
        {
          "name": "Sri Eswari Waste Paper Store",
          "address": "15, Corporation Complex, Nanmai Tharuvar Koil Street, West Masi Street, Madurai",
          "contact": "098421 84070"
        }
      ],
      "kancheepuram":[
        {
          "name": "M/s. TES-AMM INDIA PVT LTD",
          "address": "Plot No. A18, SIPCOT Industrial Growth Centre, Oragadam, Sriperumbudur Taluk, Kancheepuram Dist",
          "contact": "9500064318, 9176755506",
          "email": "kishorekumar.s@tes-amm.net"
        },
        {
          "name": "M/s. Enviro Metals Recyclers Private Limited",
          "address": "S.No. 104 and 106, Ezichur Village, Sriperumbudur Tk, Kancheepuram District",
          "contact": "9789968030",
          "email": "anbu@ensenviro.com"
        },
        {
          "name": "M/s RBIA Minerals and Metals Pvt Ltd",
          "address": "SF No. 205-1B2A, Kandur village, Sriperumbudur taluk, Kancheepuram district",
          "contact": "9444055770",
          "email": "rbiaminerals@gmail.com"
        },
        {
          "name": "M/s K.P.P enterprises",
          "address": "No. 535-3C, Santhavellore village, Sunguvarchatram post, Sriperumbudur taluk, Kancheepuram district",
          "contact": "9940858828, 7299917239",
          "email": "82.sathya@gmail.com, sppenterprices@gmail.com"
        }
      ],
      "trichy":[
        {
          "name": "M/s Micro E–Waste Recyclers",
          "address": "No. 3/3B, Chennai Bye Pass Road, Senthaneerpuram, Trichy – 620004",
          "contact": "9443141600",
          "email": "microrecyclers@yahoo.com"
        },
        {
          "name": "Aysha and Co",
          "address": "64-A, V.M.Pettai, Palakkarai, EDA Street Road, Trichy, Tiruchirappalli, Tamil Nadu 620008"
        },
        {
          "name": "ZEB CARE (Trichy)",
          "address": "No D2, Second Floor KPRS Towers, No, 62/2, Tennur High Road, Tennur, Trichy - 620017, Tamil Nadu",
          "contact": "0431-4051199",
          "email": "trichy.service@zebcare.in"
        }
      ],
      "tiruvallur":[
        {
          "name": "M/s Green E Waste Private Limited",
          "address": "SF No. 294/pt, Ayanambakkam village, Poonamallee taluk, Tiruvallur district",
          "contact": "9566214845",
          "email": "stephen.greenewaste@gmail.com"
        },
        {
          "name": "M/s JADG India E-Waste Recyclers Pvt Ltd",
          "address": "SF No.256/1A1, Kollur village, Kilikodi post, Ponneri taluk, Tiruvallur district - 601206",
          "contact": "7373919322",
          "email": "jadgewaste@gmail.com"
        },
        {
          "name": "M/s Ponniamman Enterprises",
          "address": "SF No. 216/3, Tiruvallur village, Tiruvallur taluk, Tiruvallur district",
          "contact": "9677462993",
          "email": "ponniammanenterprises@gmail.com"
        },
        {
          "name": "M/s Shri Raam Recycling",
          "address": "No.DP-29, SIDCO Industrial Estate, SIPCOT Industrial Complex, Gummidipoondi, Tiruvallur district, Pin code– 601201",
          "contact": "9884499191",
          "email": "info@shriraamrecycling.com"
        },
        {
          "name": "M/s Southern Alloys",
          "address": "Plot No. S –10 & 106, Putlur village, Tiruvallur taluk, Tiruvallur district",
          "contact": "9500038861",
          "email": "southernalloys@rediffmail.com"
        }

      ]
    };

    // Check for matching districts and return the relevant centers
    List<Map<String, String>>? centers = recyclingCenters[district];
    if (centers != null) {
      String result = "E-waste Recycling Centers in $district:\n\n";
      for (var center in centers) {
        result += "Name: ${center['name']}\n";
        result += "Address: ${center['address']}\n";
        if (center['contact'] != null && center['contact']!.isNotEmpty) {
          result += "Contact: ${center['contact']}\n";
        }
        if (center['email'] != null && center['email']!.isNotEmpty) {
          result += "Email: ${center['email']}\n";
        }
        result += "\n";
      }
      return result;
    } else {
      return "No recycling centers found for $district.";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Energy-efficient black background
      appBar: AppBar(
        title: Text(
          "E-Waste Bot",
          style: GoogleFonts.poppins( // Apply Poppins font
            color: Colors.white,
            fontWeight: FontWeight.bold, // Optional: make text bold
          ),
        ),
        backgroundColor: Colors.black, // Dark background for the AppBar
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true, // Center the title
      ),
      body: Column(
        children: [
          // Chat Messages Section
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isUser = _messages[index].containsKey("user");
                return Container(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color.fromARGB(255, 115, 104, 104) // Dark Red for user messages
                          : Colors.grey[900], // Dark Grey for bot messages
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      _messages[index][isUser ? "user" : "bot"]!,
                      style: GoogleFonts.poppins( // Apply Poppins font
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Section
          Container(
            color: Colors.black87, // Slightly lighter black for the input bar
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                // Input Field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.poppins( // Apply Poppins font
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    decoration: InputDecoration(
                      hintText: "Type your message here...",
                      hintStyle: GoogleFonts.poppins( // Apply Poppins font
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.black54, // Input background
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: 8),

                // Send Button
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 6, 59, 120), // Dark Blue button
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}