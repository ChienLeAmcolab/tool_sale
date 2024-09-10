import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {url: String, interval: Number}
  static targets = ["progressBar", "percentage"]

  connect() {
    this.timer = null
  }

  startPolling() {
    if (this.timer) return;
    this.showToast("The process is running...", "#1D9488", null, "progress-toast");
    this.updateProgress();
    this.timer = setInterval(() => {
      this.updateProgress();
    }, 1000);
  }

  stopPolling() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  async updateProgress() {
    try {
      const response = await fetch(this.urlValue)
      const data = await response.json()
      const progress = data.progress || 0
      this.progressBarTarget.style.width = `${progress}%`
      this.percentageTarget.textContent = `${progress}%`

      if (progress >= 100) {
        this.closeToast()
        this.stopPolling()
        this.showToast("The process is complete.", "#4caf50", 3000);
        await this.resetProgress();
      }
    } catch (error) {
      console.error("Error fetching progress:", error)
    }
  }

  async resetProgress() {
    try {
      const resetUrl = '/channel_setting/reset_progress';
      const toast = document.querySelector('.toast')
      toast.classList.remove('progress-toast')
      const response = await fetch(resetUrl, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json'
        },
      });
      setTimeout(() => {
        this.progressBarTarget.style.width = `0%`
        this.percentageTarget.textContent = `0%`
      }, 3000)

      if (!response.ok) {
        throw new Error('Failed to reset progress');
      }
    } catch (error) {
      console.error("Error resetting progress:", error);
    }
  }

  showToast(message, color, duration = 3000, custom_class = '') {
    const toast = document.getElementById('success-toast');
    toast.textContent = message;
    toast.style.setProperty('--toast-bg-color', color);
    toast.classList.remove('hidden');
    toast.classList.add('show');

    if (custom_class) {
      toast.classList.add(custom_class);
    }

    if (duration) {
      setTimeout(() => {
        this.closeToast();
      }, duration);
    }
  }

  closeToast() {
    const toast = document.getElementById('success-toast');
    toast.classList.remove('show');
    toast.classList.add('hidden');
  }
}
