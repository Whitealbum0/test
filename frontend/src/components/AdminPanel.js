import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import axios from "axios";

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const AdminPanel = ({ profile, onUpdate }) => {
  const [formData, setFormData] = useState({
    name: "",
    title: "",
    description: "",
    about_me: "",
    email: "",
    phone: "",
    location: "",
    social_links: {
      linkedin: "",
      github: "",
      twitter: "",
      instagram: "",
      facebook: "",
      website: ""
    },
    skills: [],
    experience: [],
    projects: []
  });

  const [newSkill, setNewSkill] = useState({ name: "", level: 50, category: "technical" });
  const [newExperience, setNewExperience] = useState({
    company: "",
    position: "",
    start_date: "",
    end_date: "",
    description: "",
    technologies: []
  });
  const [newProject, setNewProject] = useState({
    title: "",
    description: "",
    technologies: [],
    github_url: "",
    live_url: ""
  });

  const [activeTab, setActiveTab] = useState("basic");
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");

  // Helper function to check if a value is a default placeholder
  const isDefaultValue = (value, defaultText) => {
    return value === defaultText || value === `${defaultText}`;
  };

  useEffect(() => {
    if (profile) {
      setFormData({
        name: isDefaultValue(profile.name, "Ваше имя") ? "" : profile.name || "",
        title: isDefaultValue(profile.title, "Ваша профессия") ? "" : profile.title || "",
        description: isDefaultValue(profile.description, "Краткое описание о себе") ? "" : profile.description || "",
        about_me: isDefaultValue(profile.about_me, "Расскажите о себе подробнее...") ? "" : profile.about_me || "",
        email: isDefaultValue(profile.email, "your@email.com") ? "" : profile.email || "",
        phone: isDefaultValue(profile.phone, "+7 (999) 123-45-67") ? "" : profile.phone || "",
        location: isDefaultValue(profile.location, "Город, Страна") ? "" : profile.location || "",
        social_links: {
          linkedin: profile.social_links?.linkedin || "",
          github: profile.social_links?.github || "",
          twitter: profile.social_links?.twitter || "",
          instagram: profile.social_links?.instagram || "",
          facebook: profile.social_links?.facebook || "",
          website: profile.social_links?.website || ""
        },
        skills: profile.skills || [],
        experience: profile.experience || [],
        projects: profile.projects || []
      });
    }
  }, [profile]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    if (name.startsWith("social_")) {
      const socialKey = name.replace("social_", "");
      setFormData(prev => ({
        ...prev,
        social_links: {
          ...prev.social_links,
          [socialKey]: value
        }
      }));
    } else {
      setFormData(prev => ({
        ...prev,
        [name]: value
      }));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage("");

    try {
      await axios.put(`${API}/profile`, formData);
      setMessage("Профиль успешно обновлен!");
      onUpdate();
    } catch (error) {
      setMessage("Ошибка при обновлении профиля");
      console.error("Error updating profile:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleImageUpload = async (e, imageType) => {
    const file = e.target.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append("file", file);
    formData.append("image_type", imageType);

    try {
      const response = await axios.post(`${API}/profile/upload-image`, formData, {
        headers: {
          "Content-Type": "multipart/form-data"
        }
      });
      
      setMessage(`${imageType === 'avatar' ? 'Аватар' : 'Фоновое изображение'} успешно загружено!`);
      onUpdate();
    } catch (error) {
      setMessage("Ошибка при загрузке изображения");
      console.error("Error uploading image:", error);
    }
  };

  const addSkill = () => {
    if (newSkill.name.trim()) {
      setFormData(prev => ({
        ...prev,
        skills: [...prev.skills, { ...newSkill, id: Date.now().toString() }]
      }));
      setNewSkill({ name: "", level: 50, category: "technical" });
    }
  };

  const removeSkill = (index) => {
    setFormData(prev => ({
      ...prev,
      skills: prev.skills.filter((_, i) => i !== index)
    }));
  };

  const addExperience = () => {
    if (newExperience.company.trim() && newExperience.position.trim()) {
      setFormData(prev => ({
        ...prev,
        experience: [...prev.experience, { ...newExperience, id: Date.now().toString() }]
      }));
      setNewExperience({
        company: "",
        position: "",
        start_date: "",
        end_date: "",
        description: "",
        technologies: []
      });
    }
  };

  const removeExperience = (index) => {
    setFormData(prev => ({
      ...prev,
      experience: prev.experience.filter((_, i) => i !== index)
    }));
  };

  const addProject = () => {
    if (newProject.title.trim() && newProject.description.trim()) {
      setFormData(prev => ({
        ...prev,
        projects: [...prev.projects, { ...newProject, id: Date.now().toString() }]
      }));
      setNewProject({
        title: "",
        description: "",
        technologies: [],
        github_url: "",
        live_url: ""
      });
    }
  };

  const removeProject = (index) => {
    setFormData(prev => ({
      ...prev,
      projects: prev.projects.filter((_, i) => i !== index)
    }));
  };

  const handleTechnologiesChange = (value, type, setterFunction) => {
    const technologies = value.split(",").map(tech => tech.trim()).filter(tech => tech);
    setterFunction(prev => ({ ...prev, technologies }));
  };

  const tabs = [
    { id: "basic", label: "Основное", icon: "👤" },
    { id: "images", label: "Изображения", icon: "🖼️" },
    { id: "social", label: "Социальные сети", icon: "🔗" },
    { id: "skills", label: "Навыки", icon: "💪" },
    { id: "experience", label: "Опыт", icon: "💼" },
    { id: "projects", label: "Проекты", icon: "🚀" }
  ];

  return (
    <div className="min-h-screen bg-gray-900 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold">Панель администратора</h1>
          <Link
            to="/"
            className="bg-blue-600 hover:bg-blue-700 px-4 py-2 rounded-md text-sm font-medium transition-colors"
          >
            Вернуться на сайт
          </Link>
        </div>

        {message && (
          <div className={`mb-6 p-4 rounded-md ${
            message.includes("успешно") ? "bg-green-600" : "bg-red-600"
          }`}>
            {message}
          </div>
        )}

        <div className="bg-gray-800 rounded-lg shadow-xl">
          {/* Tab Navigation */}
          <div className="border-b border-gray-700">
            <nav className="flex space-x-8 px-6" aria-label="Tabs">
              {tabs.map((tab) => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`py-4 px-1 border-b-2 font-medium text-sm ${
                    activeTab === tab.id
                      ? "border-blue-500 text-blue-400"
                      : "border-transparent text-gray-300 hover:text-gray-200 hover:border-gray-300"
                  }`}
                >
                  <span className="mr-2">{tab.icon}</span>
                  {tab.label}
                </button>
              ))}
            </nav>
          </div>

          <form onSubmit={handleSubmit} className="p-6">
            {/* Basic Information Tab */}
            {activeTab === "basic" && (
              <div className="space-y-6">
                <h2 className="text-xl font-semibold mb-4">Основная информация</h2>
                
                <div className="grid md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Имя
                    </label>
                    <input
                      type="text"
                      name="name"
                      value={formData.name}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Ваше имя"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Профессия/Должность
                    </label>
                    <input
                      type="text"
                      name="title"
                      value={formData.title}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Ваша профессия"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-300 mb-2">
                    Краткое описание
                  </label>
                  <textarea
                    name="description"
                    value={formData.description}
                    onChange={handleInputChange}
                    rows={3}
                    className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="Краткое описание о себе"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-300 mb-2">
                    Подробно обо мне
                  </label>
                  <textarea
                    name="about_me"
                    value={formData.about_me}
                    onChange={handleInputChange}
                    rows={5}
                    className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="Расскажите о себе подробнее..."
                  />
                </div>

                <div className="grid md:grid-cols-3 gap-6">
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Email
                    </label>
                    <input
                      type="email"
                      name="email"
                      value={formData.email}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="your@email.com"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Телефон
                    </label>
                    <input
                      type="tel"
                      name="phone"
                      value={formData.phone}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="+7 (999) 123-45-67"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Местоположение
                    </label>
                    <input
                      type="text"
                      name="location"
                      value={formData.location}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Город, Страна"
                    />
                  </div>
                </div>
              </div>
            )}

            {/* Images Tab */}
            {activeTab === "images" && (
              <div className="space-y-6">
                <h2 className="text-xl font-semibold mb-4">Изображения</h2>
                
                <div className="grid md:grid-cols-2 gap-8">
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Аватар
                    </label>
                    <div className="border-2 border-dashed border-gray-600 rounded-lg p-6 text-center">
                      {profile?.avatar && (
                        <img
                          src={profile.avatar}
                          alt="Avatar"
                          className="w-32 h-32 rounded-full mx-auto mb-4 object-cover"
                        />
                      )}
                      <input
                        type="file"
                        accept="image/*"
                        onChange={(e) => handleImageUpload(e, "avatar")}
                        className="w-full text-sm text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-600 file:text-white hover:file:bg-blue-700"
                      />
                      <p className="text-gray-400 text-sm mt-2">
                        Рекомендуемый размер: 300x300px
                      </p>
                    </div>
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Фоновое изображение
                    </label>
                    <div className="border-2 border-dashed border-gray-600 rounded-lg p-6 text-center">
                      {profile?.background_image && (
                        <img
                          src={profile.background_image}
                          alt="Background"
                          className="w-full h-32 mx-auto mb-4 object-cover rounded"
                        />
                      )}
                      <input
                        type="file"
                        accept="image/*"
                        onChange={(e) => handleImageUpload(e, "background")}
                        className="w-full text-sm text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-600 file:text-white hover:file:bg-blue-700"
                      />
                      <p className="text-gray-400 text-sm mt-2">
                        Рекомендуемый размер: 1200x600px
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Social Links Tab */}
            {activeTab === "social" && (
              <div className="space-y-6">
                <h2 className="text-xl font-semibold mb-4">Социальные сети</h2>
                
                <div className="grid md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      LinkedIn
                    </label>
                    <input
                      type="url"
                      name="social_linkedin"
                      value={formData.social_links.linkedin}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="https://linkedin.com/in/username"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      GitHub
                    </label>
                    <input
                      type="url"
                      name="social_github"
                      value={formData.social_links.github}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="https://github.com/username"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Twitter
                    </label>
                    <input
                      type="url"
                      name="social_twitter"
                      value={formData.social_links.twitter}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="https://twitter.com/username"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Instagram
                    </label>
                    <input
                      type="url"
                      name="social_instagram"
                      value={formData.social_links.instagram}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="https://instagram.com/username"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Facebook
                    </label>
                    <input
                      type="url"
                      name="social_facebook"
                      value={formData.social_links.facebook}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="https://facebook.com/username"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Веб-сайт
                    </label>
                    <input
                      type="url"
                      name="social_website"
                      value={formData.social_links.website}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="https://yourwebsite.com"
                    />
                  </div>
                </div>
              </div>
            )}

            {/* Skills Tab */}
            {activeTab === "skills" && (
              <div className="space-y-6">
                <h2 className="text-xl font-semibold mb-4">Навыки</h2>
                
                {/* Add New Skill */}
                <div className="bg-gray-700 rounded-lg p-4">
                  <h3 className="text-lg font-medium mb-3">Добавить навык</h3>
                  <div className="grid md:grid-cols-4 gap-4">
                    <input
                      type="text"
                      value={newSkill.name}
                      onChange={(e) => setNewSkill(prev => ({ ...prev, name: e.target.value }))}
                      className="px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Название навыка"
                    />
                    <input
                      type="number"
                      min="1"
                      max="100"
                      value={newSkill.level}
                      onChange={(e) => setNewSkill(prev => ({ ...prev, level: parseInt(e.target.value) }))}
                      className="px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Уровень (1-100)"
                    />
                    <select
                      value={newSkill.category}
                      onChange={(e) => setNewSkill(prev => ({ ...prev, category: e.target.value }))}
                      className="px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="technical">Технические</option>
                      <option value="soft">Мягкие навыки</option>
                      <option value="language">Языки</option>
                    </select>
                    <button
                      type="button"
                      onClick={addSkill}
                      className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md transition-colors"
                    >
                      Добавить
                    </button>
                  </div>
                </div>
                
                {/* Skills List */}
                <div className="space-y-4">
                  {formData.skills.map((skill, index) => (
                    <div key={index} className="flex items-center justify-between bg-gray-700 rounded-lg p-4">
                      <div className="flex-1">
                        <h4 className="font-medium">{skill.name}</h4>
                        <p className="text-sm text-gray-400">
                          {skill.level}% • {skill.category}
                        </p>
                      </div>
                      <button
                        type="button"
                        onClick={() => removeSkill(index)}
                        className="text-red-400 hover:text-red-300 transition-colors"
                      >
                        Удалить
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Experience Tab */}
            {activeTab === "experience" && (
              <div className="space-y-6">
                <h2 className="text-xl font-semibold mb-4">Опыт работы</h2>
                
                {/* Add New Experience */}
                <div className="bg-gray-700 rounded-lg p-4">
                  <h3 className="text-lg font-medium mb-3">Добавить опыт</h3>
                  <div className="space-y-4">
                    <div className="grid md:grid-cols-2 gap-4">
                      <input
                        type="text"
                        value={newExperience.company}
                        onChange={(e) => setNewExperience(prev => ({ ...prev, company: e.target.value }))}
                        className="px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Компания"
                      />
                      <input
                        type="text"
                        value={newExperience.position}
                        onChange={(e) => setNewExperience(prev => ({ ...prev, position: e.target.value }))}
                        className="px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Должность"
                      />
                    </div>
                    <div className="grid md:grid-cols-2 gap-4">
                      <input
                        type="text"
                        value={newExperience.start_date}
                        onChange={(e) => setNewExperience(prev => ({ ...prev, start_date: e.target.value }))}
                        className="px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Дата начала (например: Январь 2020)"
                      />
                      <input
                        type="text"
                        value={newExperience.end_date}
                        onChange={(e) => setNewExperience(prev => ({ ...prev, end_date: e.target.value }))}
                        className="px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Дата окончания (оставьте пустым для текущей работы)"
                      />
                    </div>
                    <textarea
                      value={newExperience.description}
                      onChange={(e) => setNewExperience(prev => ({ ...prev, description: e.target.value }))}
                      className="w-full px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Описание работы"
                      rows={3}
                    />
                    <input
                      type="text"
                      value={newExperience.technologies.join(", ")}
                      onChange={(e) => handleTechnologiesChange(e.target.value, "experience", setNewExperience)}
                      className="w-full px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Технологии (через запятую)"
                    />
                    <button
                      type="button"
                      onClick={addExperience}
                      className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md transition-colors"
                    >
                      Добавить опыт
                    </button>
                  </div>
                </div>
                
                {/* Experience List */}
                <div className="space-y-4">
                  {formData.experience.map((exp, index) => (
                    <div key={index} className="bg-gray-700 rounded-lg p-4">
                      <div className="flex justify-between items-start mb-2">
                        <div>
                          <h4 className="font-medium">{exp.position}</h4>
                          <p className="text-blue-400">{exp.company}</p>
                          <p className="text-sm text-gray-400">
                            {exp.start_date} - {exp.end_date || "Настоящее время"}
                          </p>
                        </div>
                        <button
                          type="button"
                          onClick={() => removeExperience(index)}
                          className="text-red-400 hover:text-red-300 transition-colors"
                        >
                          Удалить
                        </button>
                      </div>
                      <p className="text-gray-300 mb-2">{exp.description}</p>
                      {exp.technologies && exp.technologies.length > 0 && (
                        <div className="flex flex-wrap gap-2">
                          {exp.technologies.map((tech, techIndex) => (
                            <span key={techIndex} className="bg-blue-600 text-white px-2 py-1 rounded text-sm">
                              {tech}
                            </span>
                          ))}
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Projects Tab */}
            {activeTab === "projects" && (
              <div className="space-y-6">
                <h2 className="text-xl font-semibold mb-4">Проекты</h2>
                
                {/* Add New Project */}
                <div className="bg-gray-700 rounded-lg p-4">
                  <h3 className="text-lg font-medium mb-3">Добавить проект</h3>
                  <div className="space-y-4">
                    <input
                      type="text"
                      value={newProject.title}
                      onChange={(e) => setNewProject(prev => ({ ...prev, title: e.target.value }))}
                      className="w-full px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Название проекта"
                    />
                    <textarea
                      value={newProject.description}
                      onChange={(e) => setNewProject(prev => ({ ...prev, description: e.target.value }))}
                      className="w-full px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Описание проекта"
                      rows={3}
                    />
                    <input
                      type="text"
                      value={newProject.technologies.join(", ")}
                      onChange={(e) => handleTechnologiesChange(e.target.value, "project", setNewProject)}
                      className="w-full px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Технологии (через запятую)"
                    />
                    <div className="grid md:grid-cols-2 gap-4">
                      <input
                        type="url"
                        value={newProject.github_url}
                        onChange={(e) => setNewProject(prev => ({ ...prev, github_url: e.target.value }))}
                        className="px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="GitHub URL"
                      />
                      <input
                        type="url"
                        value={newProject.live_url}
                        onChange={(e) => setNewProject(prev => ({ ...prev, live_url: e.target.value }))}
                        className="px-3 py-2 bg-gray-600 border border-gray-500 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Live Demo URL"
                      />
                    </div>
                    <button
                      type="button"
                      onClick={addProject}
                      className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md transition-colors"
                    >
                      Добавить проект
                    </button>
                  </div>
                </div>
                
                {/* Projects List */}
                <div className="space-y-4">
                  {formData.projects.map((project, index) => (
                    <div key={index} className="bg-gray-700 rounded-lg p-4">
                      <div className="flex justify-between items-start mb-2">
                        <div>
                          <h4 className="font-medium">{project.title}</h4>
                          <p className="text-gray-300 mb-2">{project.description}</p>
                          <div className="flex space-x-4 mb-2">
                            {project.github_url && (
                              <a href={project.github_url} target="_blank" rel="noopener noreferrer" className="text-blue-400 hover:text-blue-300">
                                GitHub
                              </a>
                            )}
                            {project.live_url && (
                              <a href={project.live_url} target="_blank" rel="noopener noreferrer" className="text-green-400 hover:text-green-300">
                                Live Demo
                              </a>
                            )}
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() => removeProject(index)}
                          className="text-red-400 hover:text-red-300 transition-colors"
                        >
                          Удалить
                        </button>
                      </div>
                      {project.technologies && project.technologies.length > 0 && (
                        <div className="flex flex-wrap gap-2">
                          {project.technologies.map((tech, techIndex) => (
                            <span key={techIndex} className="bg-gray-600 text-gray-300 px-2 py-1 rounded text-sm">
                              {tech}
                            </span>
                          ))}
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Submit Button */}
            <div className="flex justify-end pt-6 border-t border-gray-700">
              <button
                type="submit"
                disabled={loading}
                className="bg-blue-600 hover:bg-blue-700 disabled:bg-gray-600 text-white px-6 py-2 rounded-md font-medium transition-colors"
              >
                {loading ? "Сохранение..." : "Сохранить изменения"}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default AdminPanel;