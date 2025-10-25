package com.example.noteapp

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

class NoteViewModel(application: Application) : AndroidViewModel(application) {
    private val dao = NoteDatabase.getDatabase(application).noteDao()

    private val _notes = MutableStateFlow<List<Note>>(emptyList())
    val notes = _notes.asStateFlow()

    fun loadNotes() {
        viewModelScope.launch {
            _notes.value = dao.getAllNotes()
        }
    }

    fun addNote(title: String, content: String) {
        viewModelScope.launch {
            dao.insert(Note(title = title, content = content))
            loadNotes()
        }
    }

    fun update(note: Note) {
        viewModelScope.launch {
            dao.update(note)
            loadNotes()
        }
    }

    fun delete(note: Note) {
        viewModelScope.launch {
            dao.delete(note)
            loadNotes()
        }
    }
}
