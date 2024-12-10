package com.example.demo.service;

import com.example.demo.models.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.util.List;
import java.util.Optional;

class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    private User user;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        user = new User(1L, "testuser", "testuser@example.com", "password123");
    }

    @Test
    void testSaveUser() {
        when(userRepository.save(any(User.class))).thenReturn(user);

        // Calling the method under test
        User savedUser = userService.saveUser(user);

        // Verifying that the returned user is not null and has the expected values
        assertNotNull(savedUser);
        assertEquals("testuser", savedUser.getUsername());
        assertEquals("testuser@example.com", savedUser.getEmail());
        assertEquals("password123", savedUser.getPassword());
    }

    @Test
    void testUpdateUser() {
        when(userRepository.existsById(user.getId())).thenReturn(true);
        when(userRepository.save(any(User.class))).thenReturn(user);

        user.setUsername("updateduser");

        User updatedUser = userService.updateUser(user.getId(), user);

        assertNotNull(updatedUser);
        assertEquals("updateduser", updatedUser.getUsername());
    }

    @Test
    void testUpdateUserNotFound() {
        when(userRepository.existsById(user.getId())).thenReturn(false);

        User updatedUser = userService.updateUser(user.getId(), user);

        assertNull(updatedUser);
    }

    @Test
    void testGetUserById() {
        when(userRepository.findById(user.getId())).thenReturn(Optional.of(user));

        Optional<User> foundUser = userService.getUserById(user.getId());

        assertTrue(foundUser.isPresent());
        assertEquals(user.getUsername(), foundUser.get().getUsername());
    }

    @Test
    void testGetAllUsers() {
        when(userRepository.findAll()).thenReturn(List.of(user));

        List<User> users = userService.getAllUsers();

        assertNotNull(users);
        assertFalse(users.isEmpty());
        assertEquals("testuser", users.get(0).getUsername());
    }

    @Test
    void testDeleteUser() {
        doNothing().when(userRepository).deleteById(user.getId());

        userService.deleteUser(user.getId());

        verify(userRepository, times(1)).deleteById(user.getId());
    }
}
