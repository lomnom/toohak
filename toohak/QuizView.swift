//
//  QuizView.swift
//  toohak
//
//  Created by Nyein Nyein on 21/9/21.
//

import SwiftUI

struct Choice{
    var text: String;
    var color: Color;
    var correct: Bool;
}

struct Choices{
    init(choices: Array<Choice>){
        assert(choices.count%2==0);
        self.choices=choices;
        number=choices.count;
    }
    var number: Int;
    var choices: Array<Choice>;
}

struct ChoicesView: View {
    var choices: Choices
    var callBack: (Int) -> Void
    var body: some View {
        VStack{
            ForEach(0...(choices.number-1)/2,id: \.self) { row in
                HStack{
                    Button(action: {callBack(row*2)}){
                        Text(choices.choices[row*2].text)
                            .foregroundColor(.white)
                            .padding(5)
                    }
                        .background(choices.choices[row*2].color)
                        .cornerRadius(5)
                    Button(action: {callBack(row*2+1)}){
                        Text(choices.choices[row*2+1].text)
                            .foregroundColor(.white)
                            .padding(5)
                    }
                        .background(choices.choices[row*2+1].color)
                        .cornerRadius(5)
                }
            }
        }
    }
}

struct Question{
    var question: String;
    var choices: Choices
}

struct QuestionView: View {
    var question: Question;
    var callBack: (Int) -> Void
    var body: some View {
        VStack{
            Text(question.question)
                .padding(10)
            ChoicesView(choices: question.choices,callBack: callBack)
        }
    }
}

struct Quiz{
    var name: String;
    var questions: Array<Question>
}

struct QuestionsView: View{
    var questions: Array<Question>
    @State var currentQuestion=0;
    @State var correctQuestions=0;
    var nextQuestion: (Int,Bool) -> Void
    var callBack: (Int) -> Void
    var body: some View {
        QuestionView(
            question: questions[currentQuestion]
        ){choice in
            let question=questions[currentQuestion];
            if (question.choices.choices[choice].correct){
                correctQuestions+=1;
                nextQuestion(currentQuestion,true)
            }else{
                nextQuestion(currentQuestion,false)
            }
            if (currentQuestion==(questions.count-1)){
                callBack(correctQuestions)
            }else{
                currentQuestion+=1;
            }
        }
    }
}

struct QuizView: View{
    var quiz: Quiz
    @State var done=false;
    @State var score=0;
    @State var question=0;
    var callBack: () -> Void
    var body: some View{
        if (!done){
            ZStack{
                ZStack(alignment: .topLeading) {
                    Color.clear
                    VStack{
                        Text(quiz.name).bold().padding(7)
                        Divider()
                        Spacer()
                        VStack{
                            Text("queStIoN: \(question)/\(quiz.questions.count)")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                             Text("sCorE: \(score)")
                                .font(.system(size: 12))
                                .fontWeight(.regular)
                        }.padding(10)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                QuestionsView(
                    questions: quiz.questions,
                    nextQuestion: {question,correct in
                        if (correct){
                            self.score+=1;
                        }
                        self.question+=1;
                    }){ score in
                        done=true;
                    }
            }
        }else{
            Text("WaHH So pRo gEt \(score)/\(quiz.questions.count)!1!!!!1!").bold()
                .padding(10)
            Button(action:{callBack()}){
                Text("Press to continuee")
                    .padding(10)
                    .foregroundColor(Color.white)
            }
            .background(Color.blue)
            .cornerRadius(5)
        }
    }
}

struct QuizInfoView: View{
    var quiz: Quiz
    var callBack: (Bool) -> Void
    @State var quizzing=false;
    var body: some View{
        if (!quizzing){
            ZStack{
                VStack{
                    Text("Quiz").bold().padding(7)
                    Spacer()
                }
                ZStack(alignment: .topLeading) {
                    Color.clear
                    VStack(alignment: .leading) {
                        Button(action:{
                            callBack(false)
                        }){
                            Text("< Back")
                                .foregroundColor(.blue)
                        }.padding(7)
                        Divider()
                    }
                }
                VStack{
                    Text(quiz.name).bold().font(.system(size: 40))
                    Button(action:{
                        quizzing=true;
                    }){
                        Text("Start Quiz")
                            .foregroundColor(.white)
                            .padding(7).font(.system(size: 25))
                    }.background(Color.blue)
                     .cornerRadius(5)
                    Text("questions: \(quiz.questions.count)").font(.system(size: 15))
                }
            }
        }else{
            QuizView(quiz: quiz){
                callBack(true)
            }
        }
    }
}

struct AppView: View{
    var quizzes: Array<Quiz>;
    @State var viewing=false;
    @State var viewingItem=0;
    var body: some View{
        if (!(viewing)){
           VStack{
            Text("QuiZZES").bold()
                    .padding()
                Divider()
                List{
                    ForEach(0...quizzes.count-1,id: \.self){ id in
                        Button(action:{
                            viewing=true;
                            viewingItem=id;
                        }){
                            HStack{
                                Text("\(quizzes[id].name)")
                                    .foregroundColor(Color.black)
                                Spacer()
                                Text(">")
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                }
            }
        }else{
            QuizInfoView(quiz: quizzes[viewingItem]){ played in
                viewingItem=0;
                viewing=false;
            }
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(quizzes:
            [
                Quiz(name: "PAIN",
                     questions: [
                         Question(question: "How am i feeling",
                                  choices: Choices(
                                     choices:[
                                        Choice(text: "terible",color: .blue,correct:false),
                                        Choice(text: "terrible",color: .red,correct:true),
                                        Choice(text: "terible",color: .green,correct:false),
                                        Choice(text: "terible",color: .yellow,correct:false)
                                     ]
                                  )
                         ),
                         Question(question: "Am i alive",
                                  choices: Choices(
                                     choices:[
                                        Choice(text: "no",color: .blue,correct:true),
                                        Choice(text: "nope",color: .red,correct:true),
                                        Choice(text: "nah",color: .green,correct:true),
                                        Choice(text: "barely",color: .yellow,correct:false)
                                     ]
                                  )
                         )
                     ]
                ),
                Quiz(name: "adawdfs",
                     questions: [
                         Question(question: "is everywhere at the end of time good music to study to?",
                                  choices: Choices(
                                     choices:[
                                        Choice(text: "yes",color: .red,correct:true),
                                        Choice(text: "no",color: .blue,correct:false),
                                     ]
                                  )
                         ),
                         Question(question: "Am i coding to it",
                                  choices: Choices(
                                     choices:[
                                        Choice(text: "yes",color: .blue,correct:true),
                                        Choice(text: "no",color: .red,correct:true),
                                        Choice(text: "idk",color: .green,correct:true),
                                        Choice(text: "",color: .yellow,correct:true),
                                     ]
                                  )
                         ),
                         Question(question: "Have i eaten",
                                  choices: Choices(
                                     choices:[
                                        Choice(text: "no",color: .blue,correct:true),
                                        Choice(text: "no",color: .red,correct:true),
                                        Choice(text: "no",color: .green,correct:true),
                                        Choice(text: "no",color: .blue,correct:true),
                                        Choice(text: "no",color: .red,correct:true),
                                        Choice(text: "no",color: .green,correct:true),
                                     ]
                                  )
                         )
                     ]
                )
            ]
        )
    }
}

