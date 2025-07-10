import requests
import json
import base64
import os
import unittest
from PIL import Image
import io
import time

# Get the backend URL from the frontend .env file
with open('/app/frontend/.env', 'r') as f:
    for line in f:
        if line.startswith('REACT_APP_BACKEND_URL='):
            BACKEND_URL = line.strip().split('=')[1].strip('"\'')
            break

# Ensure the URL doesn't have quotes
BACKEND_URL = BACKEND_URL.strip('"\'')
API_URL = f"{BACKEND_URL}/api"

class BackendAPITest(unittest.TestCase):
    
    def setUp(self):
        # Ensure we're using the correct API URL
        print(f"Testing API at: {API_URL}")
        
        # Create a test image for upload tests
        self.create_test_image()
    
    def create_test_image(self):
        """Create a test image for upload testing"""
        img = Image.new('RGB', (100, 100), color='red')
        img_byte_arr = io.BytesIO()
        img.save(img_byte_arr, format='JPEG')
        self.test_image_bytes = img_byte_arr.getvalue()
    
    def test_01_api_root(self):
        """Test the API root endpoint"""
        response = requests.get(f"{API_URL}/")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data["message"], "Portfolio API is running")
        print("✅ API root endpoint is working")
    
    def test_02_get_profile_default(self):
        """Test getting the default profile when none exists"""
        # First, let's check if a profile already exists
        response = requests.get(f"{API_URL}/profile")
        self.assertEqual(response.status_code, 200)
        profile = response.json()
        
        # Verify the profile structure
        self.assertIn("id", profile)
        self.assertIn("name", profile)
        self.assertIn("title", profile)
        self.assertIn("description", profile)
        self.assertIn("email", profile)
        self.assertIn("skills", profile)
        self.assertIn("experience", profile)
        self.assertIn("projects", profile)
        self.assertIn("social_links", profile)
        
        print("✅ GET /api/profile endpoint is working")
        return profile
    
    def test_03_update_profile(self):
        """Test updating the profile"""
        # Create test profile data
        update_data = {
            "name": "John Doe",
            "title": "Full Stack Developer",
            "description": "Experienced developer with a passion for creating beautiful and functional web applications",
            "email": "john.doe@example.com",
            "phone": "+1234567890",
            "location": "New York, USA",
            "about_me": "I have been developing web applications for over 5 years...",
            "social_links": {
                "linkedin": "https://linkedin.com/in/johndoe",
                "github": "https://github.com/johndoe",
                "twitter": "https://twitter.com/johndoe"
            },
            "skills": [
                {"name": "Python", "level": 90, "category": "technical"},
                {"name": "JavaScript", "level": 85, "category": "technical"},
                {"name": "React", "level": 80, "category": "technical"}
            ],
            "experience": [
                {
                    "company": "Tech Solutions Inc.",
                    "position": "Senior Developer",
                    "start_date": "2020-01",
                    "end_date": "2023-05",
                    "description": "Led a team of developers in creating enterprise applications",
                    "technologies": ["Python", "Django", "React"]
                }
            ],
            "projects": [
                {
                    "title": "E-commerce Platform",
                    "description": "A full-featured e-commerce platform with payment integration",
                    "technologies": ["React", "Node.js", "MongoDB"],
                    "github_url": "https://github.com/johndoe/ecommerce",
                    "live_url": "https://ecommerce-demo.example.com"
                }
            ]
        }
        
        # Send PUT request to update profile
        response = requests.put(f"{API_URL}/profile", json=update_data)
        self.assertEqual(response.status_code, 200)
        updated_profile = response.json()
        
        # Verify the updated data
        self.assertEqual(updated_profile["name"], update_data["name"])
        self.assertEqual(updated_profile["title"], update_data["title"])
        self.assertEqual(updated_profile["email"], update_data["email"])
        self.assertEqual(updated_profile["phone"], update_data["phone"])
        self.assertEqual(updated_profile["location"], update_data["location"])
        self.assertEqual(updated_profile["about_me"], update_data["about_me"])
        
        # Verify social links
        self.assertEqual(updated_profile["social_links"]["linkedin"], update_data["social_links"]["linkedin"])
        self.assertEqual(updated_profile["social_links"]["github"], update_data["social_links"]["github"])
        self.assertEqual(updated_profile["social_links"]["twitter"], update_data["social_links"]["twitter"])
        
        # Verify skills
        self.assertEqual(len(updated_profile["skills"]), len(update_data["skills"]))
        for i, skill in enumerate(updated_profile["skills"]):
            self.assertEqual(skill["name"], update_data["skills"][i]["name"])
            self.assertEqual(skill["level"], update_data["skills"][i]["level"])
            self.assertEqual(skill["category"], update_data["skills"][i]["category"])
        
        # Verify experience
        self.assertEqual(len(updated_profile["experience"]), len(update_data["experience"]))
        for i, exp in enumerate(updated_profile["experience"]):
            self.assertEqual(exp["company"], update_data["experience"][i]["company"])
            self.assertEqual(exp["position"], update_data["experience"][i]["position"])
            self.assertEqual(exp["start_date"], update_data["experience"][i]["start_date"])
            self.assertEqual(exp["end_date"], update_data["experience"][i]["end_date"])
            self.assertEqual(exp["description"], update_data["experience"][i]["description"])
            self.assertEqual(exp["technologies"], update_data["experience"][i]["technologies"])
        
        # Verify projects
        self.assertEqual(len(updated_profile["projects"]), len(update_data["projects"]))
        for i, proj in enumerate(updated_profile["projects"]):
            self.assertEqual(proj["title"], update_data["projects"][i]["title"])
            self.assertEqual(proj["description"], update_data["projects"][i]["description"])
            self.assertEqual(proj["technologies"], update_data["projects"][i]["technologies"])
            self.assertEqual(proj["github_url"], update_data["projects"][i]["github_url"])
            self.assertEqual(proj["live_url"], update_data["projects"][i]["live_url"])
        
        print("✅ PUT /api/profile endpoint is working")
        return updated_profile
    
    def test_04_partial_update_profile(self):
        """Test updating only part of the profile"""
        # Create partial update data
        partial_update = {
            "title": "Senior Full Stack Developer",
            "description": "Updated description with new skills and experience"
        }
        
        # Send PUT request with partial data
        response = requests.put(f"{API_URL}/profile", json=partial_update)
        self.assertEqual(response.status_code, 200)
        updated_profile = response.json()
        
        # Verify only the specified fields were updated
        self.assertEqual(updated_profile["title"], partial_update["title"])
        self.assertEqual(updated_profile["description"], partial_update["description"])
        
        # Verify other fields remain unchanged
        self.assertEqual(updated_profile["name"], "John Doe")  # From previous test
        
        print("✅ Partial profile update is working")
    
    def test_05_upload_avatar_image(self):
        """Test uploading an avatar image"""
        files = {'file': ('test_avatar.jpg', self.test_image_bytes, 'image/jpeg')}
        response = requests.post(
            f"{API_URL}/profile/upload-image",
            files=files,
            data={'image_type': 'avatar'}
        )
        
        self.assertEqual(response.status_code, 200)
        result = response.json()
        
        self.assertIn("message", result)
        self.assertEqual(result["message"], "Image uploaded successfully")
        self.assertIn("image", result)
        self.assertTrue(result["image"].startswith("data:image/jpeg;base64,"))
        
        # Verify the image was saved to the profile
        profile_response = requests.get(f"{API_URL}/profile")
        profile = profile_response.json()
        self.assertEqual(profile["avatar"], result["image"])
        
        print("✅ Avatar image upload is working")
    
    def test_06_upload_background_image(self):
        """Test uploading a background image"""
        files = {'file': ('test_background.jpg', self.test_image_bytes, 'image/jpeg')}
        response = requests.post(
            f"{API_URL}/profile/upload-image",
            files=files,
            data={'image_type': 'background'}
        )
        
        self.assertEqual(response.status_code, 200)
        result = response.json()
        
        self.assertIn("message", result)
        self.assertEqual(result["message"], "Image uploaded successfully")
        self.assertIn("image", result)
        self.assertTrue(result["image"].startswith("data:image/jpeg;base64,"))
        
        # Verify the image was saved to the profile
        profile_response = requests.get(f"{API_URL}/profile")
        profile = profile_response.json()
        self.assertEqual(profile["background_image"], result["image"])
        
        print("✅ Background image upload is working")
    
    def test_07_invalid_image_upload(self):
        """Test uploading an invalid file type"""
        # Create a text file instead of an image
        text_data = b"This is not an image"
        
        files = {'file': ('test.txt', text_data, 'text/plain')}
        response = requests.post(
            f"{API_URL}/profile/upload-image",
            files=files,
            data={'image_type': 'avatar'}
        )
        
        self.assertEqual(response.status_code, 400)
        result = response.json()
        self.assertIn("detail", result)
        self.assertEqual(result["detail"], "File must be an image")
        
        print("✅ Invalid image upload validation is working")
    
    def test_08_status_endpoint(self):
        """Test the status endpoint"""
        # Create a status check
        status_data = {"client_name": "Backend Test Client"}
        response = requests.post(f"{API_URL}/status", json=status_data)
        self.assertEqual(response.status_code, 200)
        result = response.json()
        self.assertIn("id", result)
        self.assertEqual(result["client_name"], status_data["client_name"])
        
        # Get all status checks
        response = requests.get(f"{API_URL}/status")
        self.assertEqual(response.status_code, 200)
        status_checks = response.json()
        self.assertIsInstance(status_checks, list)
        
        # Verify our status check is in the list
        found = False
        for check in status_checks:
            if check["client_name"] == status_data["client_name"]:
                found = True
                break
        
        self.assertTrue(found, "Status check not found in the list")
        print("✅ Status endpoints are working")

if __name__ == "__main__":
    # Run the tests
    unittest.main(argv=['first-arg-is-ignored'], exit=False)