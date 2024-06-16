//
//  First_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//

import SwiftUI

struct FirstPage1: View {
    @State private var rotationAngle: Double = 0
    @State private var yeloImageName: String = "firstYelo"
    @Environment(\.scenePhase) var scenePhase
    
    let yeloImages = ["firstYelo", "firstCharlie", "firstKevin"]
    let quotes = [
        "心美，你看什麼都美；但人美，看你什麼都美。",
        "暴力不能解決事情，但可以解決你。",
        "全世界最多人信仰的是…回籠覺。萬歲萬歲萬萬歲！",
        "一個巴掌打不響，那就兩個吧！",
        "只要你不尷尬，尷尬的就是別人。",
        "我認真起來，連我自己都會怕。",
        "我鏡子照起來連我自己都怕。",
        "人生如夢、夢如氣、氣如屁，所以人生如屁。",
        "窮到只剩兩億，失億和回憶。",
        "在非洲，每六十秒，就有一分鐘過去",
        "看好了世界，我只示範一次。",
        "醫學報導連續抽菸600個月，可以多活50歲。",
        "常喝珍奶是不好的，如果戒不掉一定是這裡有賣。",
        "年輕的時候千萬不要因為沒錢而感到絕望，因為你要知道，以後沒錢的日子還很多…",
        "聽人家說…飯後抽煙對身體不好！為了健康好，那我就不吃飯了。",
        "你以為我會眼睜睜看著你去送死嗎？我會閉上眼睛。",
        "你有什麼不開心的事？講出來讓大家開心一下嘛。",
        "凡是每天喝水的人，有高機率在100年內死去",
        "每呼吸60秒，就減少一分鐘的壽命",
        "如果覺得冷，就蹲在牆角，因為那裡有90度。",
        "誰能想的到，這名16歲少女，在四年前，只是一名12歲少女",
        "我書讀得少，你不要騙我。",
        "當蝴蝶在南半球拍了兩下翅膀，牠就會稍微飛高一點點",
        "耶誕節讓我一個人過，情人節讓我一個人過，有種考試你也讓我一個人過啊！",
        "只要每天省下買一杯奶茶的錢，十天後就能買十杯奶茶",
        "不要暗戀我，你的眼神出賣你的靈魂。",
        "我吃東西不是肚子餓，只是因為嘴巴寂寞。",
        "我的優點是：我很帥，我的缺點是：我帥的不明顯。",
        "遇到你之前，我的世界是黑白的；遇見你之後，全黑了！",
        "做人要講信用…我說不還錢就是不還錢。",
        "聽說睡覺時手機放在枕頭旁會致癌，嚇得我從此不敢用枕頭了！",
        "一百萬和一千萬對我都是一樣的，因為我都沒有。",
        "我的興趣分為靜態和動態兩種，靜態就是睡覺，動態就是翻身。",
        "從猴子到人需要一萬年，從人到猴子只需一瓶酒。",
        "愛情是婚姻的墳墓，還要提防有小三來盜墓。",
        "口袋裡鈔票的顏色，決定我今天心情的顏色。",
        "我只能中午和你見面，不然的話我早晚會愛上你。",
        "小時候媽媽說，乖一點才交得到女朋友，後來發現，不乖可以同時交好幾個。",
        "如果你覺得我只有熱戀期對你好，那我們戀愛就談到熱戀期就好。",
        "在哪裡跌倒，就在那裡哭。",
        "有時候我也很佩服自己，明明薪水這麼少，卻能把自己養這麼胖。",
        "身材不投資，你就是胖子；婚姻不投資，你就是前妻；氣質不投資，你就是大媽；頭腦不投資，你就是家庭主婦；健康不投資，你就是找死；皮膚不投資，你就是黃臉婆。",
        "每天睡前喝一杯牛奶，可以幫助牛奶業者容易入睡。",
        "看到你這張臉，我還是比較喜歡我的屁股。",
        "你是獨一無二的….因為我們都不希望再有第二個。",
        "自殺不能逃避問題，但裝死可以。",
        "忍一時越想越氣，退一步越想越虧。",
        "金錢買不到一切，但可以買到我。",
        "我很會熬夜，但一點也不適合加班。",
        "「你很好，我配不上你」，是因為我已經配到更好的人了。",
        "請支援錢包。",
        "古代人慧眼識英雄，現代人會演是英雄。",
        "明明可以靠顏值吃飯，偏偏卻要工作，我不知道明明是誰，反正我是偏偏。",
        "不要問別人穿什麼好看，身材好的穿什麼都叫養眼，身材不好的穿什麼都是礙眼。",
        "只要是用錢能解決的事情，我一件都解決不了。",
        "想買什麼就買，想吃什麼就吃，多愛自己一點，畢竟沒有其他人能比自己更愛你。",
        "年輕時多吃苦，老了就習慣了。",
        "用錢真的買不到快樂，但只要有錢，別人會想盡辦法讓你快樂。",
        "條條大路通羅馬，而有些人就生在羅馬。",
        "根據報告指出 只要拿磚塊敲自己頭頭就會痛",
        "如果你哪一天過得不好，一定要記得跟我講，讓我知道，原來你也有今天。",
        "你不能讓所有人都滿意，但你能讓所有人都不滿意。",
        "做人不要妄自菲薄，你的人氣不行，但你氣人很行。",
        "有錢的時候敗家，沒錢的時候拜神。",
        "你必須非常努力，才能相信自己無能為力。",
        "天下無難事，只要肯放棄。",
        "努力不一定會成功，但不努力一定很輕鬆。",
        "在哪裡跌倒，就在哪裡躺下來。",
        "一週不見，如隔七日",
        "人生最大的問題，胖還貪吃，窮還亂買，長得醜還只喜歡正的。",
        "有一句話說：「人生是掌握在自己手中。」用力握一下手，再次確認自己真的什麼也沒有。",
        "當你不好意思拒絕別人的時候，想想別人是怎麼好意思麻煩你的。",
        "當你的左臉被人打，那你的左臉就會痛"
    ]
    @State private var currentQuote: String = ""
    
    var body: some View {
        ZStack {
            Image(yeloImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 932)
            Image("firstRocket")
            
            VStack {
                Image("firstBubble")
                    .shadow(color: .blue, radius: 2, x: 0, y: 5)
                    .overlay(
                        Text(currentQuote)
                            .font(.headline)
                            .padding()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .offset(y: -310)
                            .frame(width: 350, height: 200)
                    )
            }
            .padding(.top, 70)
        }
        .frame(width: 400, height: 932)
        .background(
            Image("firstSpace")
                .resizable()
                .scaledToFill()
                .rotationEffect(.degrees(rotationAngle))
                .onAppear {
                    startRotation()
                    randomizeImages()
                    randomizeQuote()
                }
        )
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                randomizeImages()
                randomizeQuote()
            }
        }
    }
    
    func startRotation() {
        withAnimation(
            Animation.linear(duration: 25)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
    }
    
    func randomizeImages() {
        yeloImageName = yeloImages.randomElement() ?? "firstYelo"
    }
    
    func randomizeQuote() {
        currentQuote = quotes.randomElement() ?? "Stay positive!"
    }
}

struct FirstPage1_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage1()
    }
}
