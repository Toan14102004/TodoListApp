//
//  ContentView.swift
//  TodoListApp
//
//  Created by Guest User on 25/4/25.
//
import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var newTask = ""
    @State private var editingTaskIndex: Int? = nil
    @State private var editedTaskTitle: String = ""
    @State private var showingEditAlert: Bool = false


    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Nhập công việc mới", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addTask) {
                        Image(systemName: "plus")
                    }
                }.padding()

                List {
                    ForEach(tasks.indices, id: \.self) { index in
                        HStack {
                            Text(tasks[index].title)
                                .onTapGesture {
                                    editingTaskIndex = index
                                    editedTaskTitle = tasks[index].title
                                    showingEditAlert = true
                                }
                            Spacer()
                            Image(systemName: tasks[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    tasks[index].isCompleted.toggle()
                                    saveTasks()
                                }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .alert("Chỉnh sửa công việc", isPresented: $showingEditAlert) {
                    TextField("Nội dung mới", text: $editedTaskTitle)
                    Button("Lưu", action: updateTask)
                    Button("Huỷ", role: .cancel) { }
                }

            }
            .navigationTitle("Todo List")
        }
        .onAppear(perform: loadTasks)
    }

    func updateTask() {
        if let index = editingTaskIndex {
            tasks[index].title = editedTaskTitle
            saveTasks()
        }
    }

    func addTask() {
        guard !newTask.isEmpty else { return }
        tasks.append(Task(title: newTask, isCompleted: false))
        newTask = ""
        saveTasks()
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}
#Preview {
    ContentView()
}
